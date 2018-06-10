# frozen_string_literal: true

class RemoveFolders < ActiveRecord::Migration
  def up
    drop_table :folders

    remove_column :elements, :folder_id
  end
end
