class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :property_id
      t.string :template_name

      t.timestamps null: false
    end
  end
end
