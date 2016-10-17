# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  url           :string
#  archived      :boolean          default(FALSE)
#  processed     :boolean          default(FALSE)
#

class Element < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  has_superslug :title, :slug, :context => :property

  # ---------------------------------------- Attributes

  attr_accessor :skip_geocode

  # ---------------------------------------- Associations

  belongs_to :property, :touch => true

  # ---------------------------------------- Scopes

  scope :with_template, ->(name) { where(:template_name => name.split(',')) }
  scope :by_title, -> { order(:title => :asc) }
  scope :by_field, ->(attr) { order("template_data ->> '#{attr}'") }
  scope :starting_with, ->(letter) { where('title like ?', "#{letter}%") }
  scope :starting_with_number, -> { where('title ~* ?', '^\d(.*)?') }

  # ---------------------------------------- Validations

  validates :title, :template_name, :presence => true

  # ---------------------------------------- Callbacks

  after_save :geocode_addresses

  def geocode_addresses
    return unless template? && skip_geocode.blank?
    template.geocode_fields.each do |field|
      val = template_data[field.name]
      if val.blank?
        template_data[field.name] = { :raw => nil }
        next
      end
      begin
        val = val[:raw] if val.is_a?(Hash) && val[:raw].present?
        template_data[field.name] = Geokit::Geocoders::GoogleGeocoder
          .geocode(val).to_hash.merge(:raw => val)
      rescue
        # If we hit too many queries, we can sleep for a second and then try
        # again.
        sleep 1
        template_data[field.name] = Geokit::Geocoders::GoogleGeocoder
          .geocode(val).to_hash.merge(:raw => val)
      end
    end
    update_columns(:template_data => template_data)
  end

  after_save :init_webhook

  before_validation :set_title

  def set_title
    set_document_title if document?
    return if template.blank? || template.primary_field.blank? ||
              self.send(template.primary_field.name).blank?
    self.title = self.send(template.primary_field.name)
  end

  after_create :process_images!, :if => :document?

  def process_images!
    return nil if Rails.env.test?
    ProcessImages.delay.call(:document => self) if image? && !processed?
  end

  # ---------------------------------------- Document Properties

  def set_document_title
    return false unless document?
    if title.blank? || url.present?
      self.title = title_from_filename
      return unless template.primary_field
      self.template_data[template.primary_field.name.to_sym] = title_from_filename
    end
  end

  def title_from_filename
    return nil unless document?
    url.split('/').last.split('.').first.titleize
  end

  def document?
    return false unless template?
    template.document?
  end

  def filename
    return nil unless document?
    url.split('/').last
  end

  def filename_no_ext
    return nil unless document?
    filename.split('.')[0..-2].join('.')
  end

  def file_ext
    return nil unless document?
    url.split('.').last.downcase
  end

  def safe_url
    return nil unless document?
    URI.encode(url)
  end

  def uri
    return nil unless document?
    URI.parse(safe_url)
  end

  def s3_base
    return nil unless document?
    "#{uri.scheme}://#{uri.host}"
  end

  def s3_dir
    return nil unless document?
    uri.path.split('/').reject(&:blank?)[0..-2].join('/')
  end

  def version(name, crop = false)
    return nil unless document?
    return safe_url.to_s if !processed? || !image?
    alt = crop ? '_crop' : nil
    filename = "#{filename_no_ext}_#{name.to_s}#{alt}.#{file_ext}"
    URI.encode("#{s3_base}/#{s3_dir}/#{filename}")
  end

  def image?
    return false unless document?
    %(jpeg jpg png gif svg).include?(file_ext)
  end

  def archive!
    return false unless document?
    update_columns(:archived => true)
  end

  def processed!
    return false unless document?
    update_columns(:processed => true)
  end

  # ---------------------------------------- Instance Methods

  def template
    return property.find_template(template_name) unless Rails.env.production?
    Rails.cache.fetch("_p#{property_id}_e#{id}_template") do
      property.find_template(template_name)
    end
  end

  def template?
    template.present?
  end

  def association_names
    return [] unless template?
    template.associations.collect(&:name)
  end

  def has_association?(name)
    association_names.include?(name.to_s)
  end

  def field_names
    return [] unless template?
    template.fields.collect(&:name)
  end

  def has_field?(name)
    field_names.include?(name.to_s)
  end

  def send_notifications!(action_name, excluding_user)
    return false unless template?
    notifications = property.notifications.for_template(template)
    if excluding_user.present?
      notifications = notifications.without_user(excluding_user)
    end
    notifications.each do |n|
      NotificationMailer.notify(
        :element => self,
        :notification => n,
        :action_name => action_name,
        :template => template,
        :property => property
      ).deliver_now
    end
  end

  def to_param
    id.to_s
  end

  def to_s
    title
  end

  def as_json(options = {})
    response = {
      :id => id,
      :title => title,
      :slug => slug,
      :template_name => template_name,
      :publish_at => publish_at,
      :created_at => created_at,
      :updated_at => updated_at,
    }
    return response unless template?
    template_data.each do |k,v|
      field = template.find_field(k)
      next if field.nil?
      response[k.to_sym] = field.sendable? ? send(k) : v
      # TODO: Quick fix for geocode fields -- need a test for this
      if response[k.to_sym].is_a?(OpenStruct)
        response[k.to_sym] = response[k.to_sym].marshal_dump
      end
    end
    if document?
      response[:url] = url
      if image? && processed?
        response[:versions] = {}
        %w(xsmall small medium large xlarge).each do |v|
          response[:versions][:"#{v}"] = version(v, false)
          response[:versions][:"#{v}_crop"] = version(v, true)
        end
      end
    end
    if options[:includes].present?
      options[:includes].split(',').each do |association|
        response[association.to_sym] = send(association)
      end
    end
    response
  end

  def method_missing(method, *arguments, &block)
    return super unless has_field?(method.to_s) || has_association?(method.to_s)
    if has_field?(method.to_s)
      field = template.find_field(method.to_s)
      case field.type
      when 'element'
        return nil if template_data[method.to_s].blank?
        unless Rails.env.production?
          return property.elements.find_by_id(template_data[method.to_s])
        end
        Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
          property.elements.find_by_id(template_data[method.to_s])
        end
      when 'elements'
        return [] if template_data[method.to_s].blank?
        element_ids = template_data[method.to_s].split(',').collect(&:to_i)
        unless Rails.env.production?
          raw_els = property.elements.where(:id => element_ids) || []
          elements = []
          element_ids.each do |id|
            el = raw_els.select { |e| e.id == id }[0]
            elements << el unless el.blank?
          end
          return elements
        end
        Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
          raw_els = property.elements.where(:id => element_ids) || []
          elements = []
          element_ids.each do |id|
            el = raw_els.select { |e| e.id == id }[0]
            elements << el unless el.blank?
          end
          return elements
        end
      when 'geocode'
        geo = template_data[method.to_s]
        geo.is_a?(Hash) ? geo.to_ostruct : geo
      when 'boolean'
        template_data[method.to_s].to_bool
      else
        template_data[method.to_s]
      end
    elsif has_association?(method.to_s)
      association = template.find_association(method.to_s)
      unless Rails.env.production?
        return property
          .elements.by_title.with_template(association.template)
          .reject { |e| e.template_data[association.field].blank? }
          .select { |e| e.template_data[association.field].split(',')
              .collect(&:to_i).include?(id) }
      end
      Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
        property
          .elements.by_title.with_template(association.template)
          .reject { |e| e.template_data[association.field].blank? }
          .select { |e| e.template_data[association.field].split(',')
              .collect(&:to_i).include?(id) }
      end
    end
  end

  private

    def init_webhook
      return false unless template?
      Webhook.delay.call(:element => self) if template.webhook?
    end

end
