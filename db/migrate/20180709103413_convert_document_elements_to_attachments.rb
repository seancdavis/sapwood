# frozen_string_literal: true

class ConvertDocumentElementsToAttachments < ActiveRecord::Migration[5.2]

  def up
    Property.all.each do |property|
      property_config = JSON.parse(property.templates_raw)
      # 1. Find templates that are document type
      property.templates.select { |t| t.attributes['type'] == 'document' }.each do |tmpl|
        # 2. Store record of each element's reference to title, url
        elements = property.elements.where(template_name: tmpl.name)
        attachment_list = {}
        elements.each do |el|
          next if el.url.blank?
          attachment_list[el.id.to_s] = { title: el.title, url: URI.decode(el.url.to_s) }
        end
        # 3. Update template config with attachment settings
        conf = property_config.detect { |c| c['title'] == tmpl.name }
        conf.except!('type')
        conf['fields']['attachment'] = { 'type' => 'attachment', 'required' => true }
        property.update!(templates_raw: property_config.to_json)
        # 4. Loop through elements and create attachments and reference to element
        attachment_list.each do |id, data|
          el = elements.detect { |el| el.id == id.to_i }
          attachment = Attachment.create!(property_id: property.id, title: data[:title], url: data[:url])
          el.template_data.merge!('attachment' => attachment.id.to_s)
          el.save!
        end
      end
    end

    remove_column :elements, :url
    remove_column :elements, :publish_at
  end

  def down
    add_column :elements, :url, :string
    add_column :elements, :publish_at, :datetime
  end

end
