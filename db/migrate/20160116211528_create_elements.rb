# frozen_string_literal: true

class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :title
      t.string :slug
      t.integer :property_id
      t.string :template_name
      t.integer :position, default: 0
      t.text :body
      t.json :template_data
      t.string :ancestry
      t.datetime :publish_at

      t.timestamps null: false
    end
  end
end
