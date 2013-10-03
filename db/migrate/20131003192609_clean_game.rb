class CleanGame < ActiveRecord::Migration
  def change
    remove_column :games, :team_home_score
    remove_column :games, :team_away_score
    remove_column :games, :strike_count
    remove_column :games, :out_count
    remove_column :games, :ball_count
  end
end
