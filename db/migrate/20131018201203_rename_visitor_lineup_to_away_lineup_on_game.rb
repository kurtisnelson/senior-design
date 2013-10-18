class RenameVisitorLineupToAwayLineupOnGame < ActiveRecord::Migration
  def change
    rename_column :games, :visitor_lineup, :away_lineup
  end
end
