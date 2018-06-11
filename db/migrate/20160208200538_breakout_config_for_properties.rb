# frozen_string_literal: true

class BreakoutConfigForProperties < ActiveRecord::Migration

  def change
    remove_column :properties, :config, :json
    add_column :properties, :color, :string
    add_column :properties, :labels, :json
    add_column :properties, :templates_raw, :text
    add_column :properties, :forms_raw, :text
  end

end
