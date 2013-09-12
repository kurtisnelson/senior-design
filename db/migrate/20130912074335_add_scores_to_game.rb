class AddScoresToGame < ActiveRecord::Migration
  def change
    add_reference :games, :team_away, index: true
    add_reference :games, :team_home, index: true
    add_column :games, :team_home_score, :int
    add_column :games, :team_away_score, :int
  end
end
