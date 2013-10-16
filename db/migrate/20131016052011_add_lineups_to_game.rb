class AddLineupsToGame < ActiveRecord::Migration
  def change
    add_column :games, :home_lineup, :string
    add_column :games, :visitor_lineup, :string
  end
end
