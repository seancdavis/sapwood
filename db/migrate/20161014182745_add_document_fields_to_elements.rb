class AddDocumentFieldsToElements < ActiveRecord::Migration

  def change
    add_column :elements, :url, :string
    add_column :elements, :archived, :boolean, default: false
    add_column :elements, :processed, :boolean, default: false
  end

end
