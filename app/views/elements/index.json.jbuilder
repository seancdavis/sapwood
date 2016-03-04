json.array! current_property.elements.alpha do |element|
  json.id element.id
  json.title element.title
  json.template_name element.template_name
end
