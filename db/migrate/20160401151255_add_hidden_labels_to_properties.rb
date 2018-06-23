class AddHiddenLabelsToProperties < ActiveRecord::Migration

  def change
    add_column :properties, :hidden_labels, :text, array: true,
               default: []
  end

end
