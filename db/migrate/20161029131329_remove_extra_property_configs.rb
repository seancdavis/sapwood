class RemoveExtraPropertyConfigs < ActiveRecord::Migration

  def change
    remove_column :properties, :labels, :json
    remove_column :properties, :forms_raw, :text
    remove_column :properties, :hidden_labels, :text
    remove_column :properties, :collection_types_raw, :text
  end

end
