desc 'A changing task to update or transition data or code'
task :update => :environment do

  Property.all.each do |property|

    template_config_was = JSON.parse(property.templates_raw)
    template_config = JSON.parse(property.templates_raw)

    property.collection_types.each do |collection_type|
      ct_config = {
        "title": collection_type.title,
        "fields": {
          "name": {
            "primary": true
          },
          "items": {
            "type": "elements"
          }
        }
      }
      if collection_type.template != '__all'
        ct_config[:fields][:items]["templates"] = [collection_type.template]
      end
      if collection_type.fields.present?
        collection_type.fields.each do |field|
          ct_config[:fields][field.name] = {
            "type": field.type,
            "label": field.label
          }
        end
      end
      template_config << ct_config

      property.collections.with_type(collection_type.title).each do |collection|
        items = {
          "name" => collection.title,
          "items" => collection.element_ids.join(',')
        }
        property.elements.create(
          :title => collection.title,
          :template_data => collection.field_data.merge(items),
          :template_name => collection_type.name
        )
        puts "CREATED COLLECTION ELEMENT: #{collection.title}"
      end
    end

    template_config << {
      "title": "Document",
      "type": "document",
      "fields": {
        "name": {
          "primary": true
        }
      }
    }

    document_ids = []
    property.documents.each do |document|
      new_el = property.elements.create(
        :title => document.title,
        :url => document.url,
        :archived => document.archived,
        :processed => document.processed,
        :template_name => 'Document',
        :template_data => { "name": document.title }
      )
      puts "CREATED DOCUMENT ELEMENT: #{document.title}"
      document_ids << { :old => document.id, :new => new_el.id }
    end

    property.templates.each do |template|
puts "-- Entering template: #{template.name}"
      doc_fields = template.fields.select { |f| f.document? || f.documents? }
      if doc_fields.present?
puts "-- -- Has doc fields: #{doc_fields.collect(&:name)}"
        property.elements.with_template(template.title).each do |el|
puts "-- -- -- In element: #{el.title}"
          template_data = el.template_data
puts "-- -- -- -- Initial template data: #{template_data}"
          doc_fields.each do |field|
puts "-- -- -- -- -- Entering field: #{field.name}"
            tmpl = template_config.select { |t| t['title'] == template.title }[0]
            idx = template_config.index(tmpl)
puts "-- -- -- -- -- -- Found template config at index: #{idx}"
puts "-- -- -- -- -- -- Current template config for that field: #{template_config[idx]['fields'][field.name]}"
            template_config[idx]['fields'][field.name]['type'] =
              field.document? ? 'element' : 'elements'
            template_config[idx]['fields'][field.name]['templates'] =
              ["Document"]
            new_ids = []
puts "-- -- -- -- -- -- Current field value: #{el.template_data[field.name]}"
            next unless el.template_data[field.name].present?
puts "-- -- -- -- -- -- Looking to replace document id fields ..."
            el.template_data[field.name].split(',').collect(&:to_i).each do |id|
              doc_id = document_ids.select { |ids| ids[:old] == id }[0]
              next unless doc_id.present?
puts "-- -- -- -- -- -- Found old id: #{doc_id[:old]}"
              new_ids << doc_id[:new]
puts "-- -- -- -- -- -- Added new id: #{doc_id[:new]}"
            end
            template_data[field.name] = new_ids.join(',')
puts "-- -- -- -- Current template data: #{template_data}"
          end
          el.template_data_will_change!
          el.update!(:template_data => template_data, :skip_geocode => true)
          puts "SAVED REFERENCE TO DOCS: #{el.title}"
        end
      else
puts "-- -- Found no doc fields."
      end
    end

    property.templates_raw_will_change!
    property.templates_raw = template_config.to_json
    property.save!
  end

end
