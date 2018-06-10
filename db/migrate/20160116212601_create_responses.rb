# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :property_id
      t.json :data

      t.timestamps null: false
    end
  end
end
