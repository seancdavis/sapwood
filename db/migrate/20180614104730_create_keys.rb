require 'pry'

class CreateKeys < ActiveRecord::Migration[5.2]

  def up
    create_table :keys do |t|
      t.integer :property_id
      t.boolean :writeable, default: false
      t.text :template_names, array: true, default: []
      t.string :encrypted_value

      t.timestamps
    end

    Property.all.each do |property|
      Key.create!(property: property, value: property.api_key)
    end

    # remove_column :properties, :api_key
  end

  def down
    drop_table :keys
  end

end
