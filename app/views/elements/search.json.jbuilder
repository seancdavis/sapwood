# frozen_string_literal: true

json.array! @elements do |element|
  json.id element.id
  json.title element.title
  json.template_name element.template_name
  json.url edit_property_template_element_path(element.property, element.template, element)
end
