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
#  ancestry      :string
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Element < ActiveRecord::Base

  # ---------------------------------------- Plugins

  include Presenter

  has_ancestry

  has_superslug :title, :slug, :context => :property

  # ---------------------------------------- Associations

  belongs_to :property

  # ---------------------------------------- Scopes

  scope :alpha, -> { order(:title => :asc) }

  # ---------------------------------------- Validations

  validates :title, :template_name, :presence => true

  # ---------------------------------------- Instance Methods

  def template
    property.find_template(template_name)
  end

  def to_param
    id.to_s
  end

  def method_missing(method, *arguments, &block)
    return super unless template.fields.collect(&:name).include?(method.to_s)
    field = template.find_field(method.to_s)
    case field.type
    when 'geocode'
      {
        :raw => template_data[method.to_s],
        :full_address => template_data["#{method.to_s}_full_address"],
        :street_address => template_data["#{method.to_s}_street_address"],
        :city => template_data["#{method.to_s}_city"],
        :state => template_data["#{method.to_s}_state"],
        :country_code => template_data["#{method.to_s}_country_code"],
        :zip => template_data["#{method.to_s}_zip"],
        :lat => template_data["#{method.to_s}_lat"],
        :lng => template_data["#{method.to_s}_lng"]
      }.to_ostruct
    else
      template_data[method.to_s]
    end
  end

end
