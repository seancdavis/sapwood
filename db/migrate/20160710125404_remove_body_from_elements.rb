class RemoveBodyFromElements < ActiveRecord::Migration
  def change
    remove_column :elements, :body, :text
  end
end
