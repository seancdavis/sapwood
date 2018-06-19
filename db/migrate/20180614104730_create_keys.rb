# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[5.2]

  def up
    create_table :keys do |t|
      t.string :title
      t.integer :property_id
      t.boolean :writable, default: false
      t.text :template_names, array: true, default: []
      t.string :encrypted_value

      t.timestamps
    end

    Property.all.each do |property|
      Key.create!(title: "#{property.title} Read Key", property: property, value: property.api_key)

      property.templates.each do |tmpl|
        allow = tmpl.try(:security).try(:create).try(:allow)
        key = tmpl.try(:security).try(:create).try(:secret)
        next unless allow.present? && key.present?
        Key.create!(
          title: "#{tmpl.title} Write Key",
          property: property,
          value: key,
          writable: true,
          template_names: [tmpl.title]
        )
      end
    end

    remove_column :properties, :api_key
  end

  def down
    drop_table :keys
  end

end
