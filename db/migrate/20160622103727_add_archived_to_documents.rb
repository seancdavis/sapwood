class AddArchivedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :archived, :boolean, :default => false
  end
end
