class AddSignInKeyToUsers < ActiveRecord::Migration

  def change
    add_column :users, :sign_in_key, :string
  end

end
