json.document do
  json.id @document.id
  json.url edit_property_template_document_path(current_property, current_template, @document)
  json.name @document.title
  json.file_type @document.p.file_type
end
