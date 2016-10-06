module CollectionsHelper

  def collection_elements_path
    property_template_elements_path(current_property,
                                    current_collection_type.template)
  end

end
