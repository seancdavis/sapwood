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
#

class Element < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  has_superslug :title, :slug, :context => :property

  # ---------------------------------------- Associations

  belongs_to :property, :touch => true

  # ---------------------------------------- Scopes

  scope :alpha, -> { order(:title => :asc) }
  scope :with_template, ->(name) { where(:template_name => name) }
  scope :by_title, -> { order(:title => :asc) }
  scope :by_field, ->(attr) { order("template_data ->> '#{attr}'") }

  # ---------------------------------------- Validations

  validates :title, :template_name, :presence => true

  # ---------------------------------------- Callbacks

  after_save :geocode_addresses

  def geocode_addresses
    return unless template?
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
    return if template.blank? || template.primary_field.blank? ||
              self.send(template.primary_field.name).blank?
    self.title = self.send(template.primary_field.name)
  end

  # ---------------------------------------- Instance Methods

  def template
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

  def to_param
    id.to_s
  end

  def as_json(options = {})
    response = {
      :id => id,
      :title => title,
      :slug => slug,
      # :property_id => property_id,
      :template_name => template_name,
      # :template_data => template_data,
      :publish_at => publish_at,
      :created_at => created_at,
      :updated_at => updated_at,
    }
    template_data.each do |k,v|
      field = template.find_field(k)
      next if field.nil?
      response[k.to_sym] = if field.document? || field.element?
         send(k)
       else
        v
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
        Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
          Element.find_by_id(template_data[method.to_s])
        end
      when 'document'
        return nil if template_data[method.to_s].blank?
        Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
          Document.find_by_id(template_data[method.to_s])
        end
      when 'geocode'
        template_data[method.to_s].to_ostruct
      else
        template_data[method.to_s]
      end
    elsif has_association?(method.to_s)
      association = template.find_association(method.to_s)
      Rails.cache.fetch("_p#{property_id}_e#{id}_#{method.to_s}") do
        property
          .elements.by_title.with_template(association.template)
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
