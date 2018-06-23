class CreateDocuments < ActiveRecord::Migration

  def change
    create_table :documents do |t|
      t.string :title
      t.string :f
      t.integer :property_id

      t.timestamps null: false
    end
  end

end
