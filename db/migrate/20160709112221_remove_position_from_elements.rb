# frozen_string_literal: true

class RemovePositionFromElements < ActiveRecord::Migration
  def change
    remove_column :elements, :position, :integer
  end
end
