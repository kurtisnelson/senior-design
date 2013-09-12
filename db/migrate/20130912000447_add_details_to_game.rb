class AddDetailsToGame < ActiveRecord::Migration
  def change
    add_column :games, :team1, :int
    add_column :games, :team2, :int
    add_column :games, :team1_score, :int
    add_column :games, :team2_score, :int
    add_column :games, :status, :int
  end
end
