# frozen_string_literal: true

class ChangeFToUrlInDocuments < ActiveRecord::Migration

  def change
    rename_column :documents, :f, :url
  end

end
