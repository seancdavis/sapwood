# frozen_string_literal: true

json.document do
  json.id @attachment.id
  json.url edit_property_attachment_path(current_property, @attachment)
  json.name @attachment.title
  json.file_type @attachment.file_ext
end
