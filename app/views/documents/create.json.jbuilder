json.document do
  json.id @document.id
  json.url edit_property_document_path(current_property, @document)
  json.name @document.title
  json.file_type @document.p.file_type
end
