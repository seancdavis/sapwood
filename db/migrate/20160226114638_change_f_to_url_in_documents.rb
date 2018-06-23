class ChangeFToUrlInDocuments < ActiveRecord::Migration

  def change
    rename_column :documents, :f, :url
  end

end
