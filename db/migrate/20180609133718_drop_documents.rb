class DropDocuments < ActiveRecord::Migration[5.2]
  def change
    drop_table :documents
  end
end
