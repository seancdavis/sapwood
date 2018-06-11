class ConvertGeocodeFieldsToText < ActiveRecord::Migration[5.2]

  def up
    Property.all.each do |property|
      config = JSON.parse(property.templates_raw)
      update = false
      config.each_with_index do |data, idx|
        data.deep_stringify_keys!
        data['fields'].each do |name, fdata|
          if fdata['type'] == 'geocode'
            config[idx]['fields'][name]['type'] = 'text'
            update = true
          end
        end
      end
      property.update_columns(templates_raw: config.to_json) if update
    end
  end

end
