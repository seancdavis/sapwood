class AddCollectionsRawToProperties < ActiveRecord::Migration

  def change
    add_column :properties, :collection_types_raw, :text

    Property.reset_column_information
    Property.all.each { |p| p.save! }
  end

end
