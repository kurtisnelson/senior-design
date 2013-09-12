class RemoveScoresFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :team1, :int
    remove_column :games, :team2, :int
    remove_column :games, :team1_score, :int
    remove_column :games, :team2_score, :int
  end
end
