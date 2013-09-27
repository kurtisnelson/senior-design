class AddStrikeBallOutToGame < ActiveRecord::Migration
  def change
    add_column :games, :strike_count, :integer, :default => 0
    add_column :games, :ball_count, :integer, :default => 0
    add_column :games, :out_count, :integer, :default => 0
  end
end
