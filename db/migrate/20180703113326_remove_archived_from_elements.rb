# frozen_string_literal: true

class RemoveArchivedFromElements < ActiveRecord::Migration[5.2]

  def change
    remove_column :elements, :archived, :boolean, default: false
  end

end
