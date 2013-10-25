class ChangeStatsTeamIdToGameId < ActiveRecord::Migration
  def change
    rename_column :stats, :team_id, :game_id
  end
end
