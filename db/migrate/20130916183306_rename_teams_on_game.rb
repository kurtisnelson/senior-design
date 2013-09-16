class RenameTeamsOnGame < ActiveRecord::Migration
  def change
    rename_column :games, :team_away_id, :away_team_id
    rename_column :games, :team_home_id, :home_team_id
  end
end
