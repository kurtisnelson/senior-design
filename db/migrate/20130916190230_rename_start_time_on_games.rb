class RenameStartTimeOnGames < ActiveRecord::Migration
  def change
    change_column :games, :start_time, :time
    add_column :games, :start_date, :date
  end
end
