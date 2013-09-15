class RenameUsernameToName < ActiveRecord::Migration
  def change
    rename_column :users, :username, :name
    remove_column :users, :provider, :string
  end
end
