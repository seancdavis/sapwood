# frozen_string_literal: true

class AddIsAdminToPropertyUsers < ActiveRecord::Migration
  def change
    add_column :property_users, :is_admin, :boolean, default: false
  end
end
