class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :bytea
  end
end
