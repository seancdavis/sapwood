class ChangeItemDataToText < ActiveRecord::Migration
  def change
    change_column :collections, :item_data, :text
  end
end
