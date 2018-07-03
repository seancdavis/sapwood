# frozen_string_literal: true

class RemoveProcessedFromDocsAndElements < ActiveRecord::Migration[5.2]

  def change
    remove_column :elements, :processed, :boolean, default: false
  end

end
