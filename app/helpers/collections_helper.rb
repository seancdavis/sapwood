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
#  field_data           :json             default({})
#

module CollectionsHelper

  def collection_elements_path
    property_template_elements_path(current_property,
                                    current_collection_type.template)
  end

end
