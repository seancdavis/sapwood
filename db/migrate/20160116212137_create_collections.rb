class CreateCollections < ActiveRecord::Migration

  def change
    create_table :collections do |t|
      t.string :title
      t.integer :property_id
      t.json :item_data

      t.timestamps null: false
    end
  end

end
