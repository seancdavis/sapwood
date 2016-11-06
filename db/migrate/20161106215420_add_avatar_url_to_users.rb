class AddAvatarUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_url, :string

    User.reset_column_information
    User.all.collect(&:save)
  end
end
