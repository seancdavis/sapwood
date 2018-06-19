# frozen_string_literal: true

class CreateFolders < ActiveRecord::Migration

  def change
    create_table :folders do |t|
      t.string :title
      t.string :slug
      t.string :ancestry
      t.integer :property_id
      t.integer :position, default: 0

      t.timestamps null: false
    end

    remove_column :elements, :ancestry, :string
    add_column :elements, :folder_id, :integer
  end

end
