# frozen_string_literal: true

class AddFieldDataToCollections < ActiveRecord::Migration

  def change
    add_column :collections, :collection_type_name, :string
    add_column :collections, :field_data, :json, default: {}

    Collection.reset_column_information
    Collection.all.includes(:property).each do |c|
      c.update(collection_type_name: c.property.collection_types.first.title)
    end
  end

end
