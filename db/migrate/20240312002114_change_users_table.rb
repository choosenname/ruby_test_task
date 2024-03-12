class ChangeUsersTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :password
    add_column :users, :password_digest, :string, null: false

    add_index :users, :email, unique: true
  end
end
