class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.integer :property_id
      t.boolean :writeable, default: false
      t.text :template_names, array: true, default: []
      t.string :encrypted_value

      t.timestamps
    end
  end
end
