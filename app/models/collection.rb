# == Schema Information
#
# Table name: collections
#
#  id                   :integer          not null, primary key
#  title                :string
#  property_id          :integer
#  item_data            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  collection_type_name :string
#  field_data           :json
#

class Collection < ActiveRecord::Base

  # ---------------------------------------- Associations

  belongs_to :property

  # ---------------------------------------- Validations

  validates :title, :collection_type_name, :presence => true

  # ---------------------------------------- Instance Methods

  def element_ids
    return [] if item_data.blank?
    ids = []
    JSON.parse(item_data).each do |k, v|
      ids << k['id']
      k['children'].each do |k, v|
        ids << k['id']
        k['children'].each { |k, v| ids << k['id'] }
      end
    end
    ids.collect(&:to_i)
  end

  def elements
    property.elements.where(:id => element_ids)
  end

  def field_names
    return [] unless collection_type?
    collection_type.fields.collect(&:name)
  end

  def has_field?(name)
    field_names.include?(name.to_s)
  end

  def collection_type
    return nil if property.nil?
    property.find_collection_type(collection_type_name)
  end

  def collection_type?
    collection_type.present?
  end

  def as_json(options)
    els = elements
    ids = element_ids
    items = []
    JSON.parse(item_data).each do |k1, v1|
      e1 = els.select { |e| e.id == k1['id'] }.first
      c1 = []
      k1['children'].each do |k2, v2|
        e2 = els.select { |e| e.id == k2['id'] }.first
        c2 = []
        k2['children'].each do |k3, v3|
          e3 = els.select { |e| e.id == k3['id'] }.first
          c2 << e3.as_json({})
        end
        c1 << e2.as_json({}).merge(:children => c2)
      end
      items << e1.as_json({}).merge(:children => c1)
    end
    { :id => id, :title => title, :items => items }
  end

  def method_missing(method, *arguments, &block)
    return super unless has_field?(method.to_s)
    field_data[method.to_s]
  end

end
