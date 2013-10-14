class AddPlayerNumberToTeamsUsers < ActiveRecord::Migration
  def change
  	add_column :teams_users, :player_number, :integer
  	rename_table :teams_users, :players
  end
end
