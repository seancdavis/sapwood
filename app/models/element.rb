# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  position      :integer          default(0)
#  body          :text
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  folder_id     :integer
#

class Element < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  has_superslug :title, :slug, :context => :property

  # ---------------------------------------- Associations

  belongs_to :property, :touch => true
  belongs_to :folder

  # ---------------------------------------- Scopes

  scope :alpha, -> { order(:title => :asc) }
  scope :roots, -> { where(:folder_id => nil) }
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

  # ---------------------------------------- Instance Methods

  def template
    property.find_template(template_name)
  end

  def template?
    template.present?
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
      :body => body,
      :template_name => template_name,
      :position => position,
      # :template_data => template_data,
      :publish_at => publish_at,
      :created_at => created_at,
      :updated_at => updated_at,
      # :folder_id => folder_id
    }
    template_data.each do |k,v|
      response[k.to_sym] = if template.find_field(k).is_document?
         Document.find_by_id(v)
       else
        v
      end
    end
    response
  end

  def method_missing(method, *arguments, &block)
    return super unless has_field?(method.to_s)
    field = template.find_field(method.to_s)
    case field.type
    when 'geocode'
      template_data[method.to_s].to_ostruct
    when 'document'
      return nil if template_data[method.to_s].blank?
      Document.find_by_id(template_data[method.to_s])
    else
      template_data[method.to_s]
    end
  end

  private

    def init_webhook
      return false unless template?
      Webhook.delay.call(:element => self) if template.has_webhook?
    end

end
