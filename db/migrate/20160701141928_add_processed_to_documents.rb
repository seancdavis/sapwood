class AddProcessedToDocuments < ActiveRecord::Migration

  def change
    add_column :documents, :processed, :boolean, default: false
  end

end
