class DontAllowElementTemplateDataToBeEmpty < ActiveRecord::Migration
  def change
    change_column :elements, :template_data, :json, :default => {}
  end
end