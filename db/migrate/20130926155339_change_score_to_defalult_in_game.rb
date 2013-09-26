class ChangeScoreToDefalultInGame < ActiveRecord::Migration
  def change
  	change_column :games, :team_home_score, :integer, {default: 0}
  	change_column :games, :team_away_score, :integer, {default: 0}
  end
end
