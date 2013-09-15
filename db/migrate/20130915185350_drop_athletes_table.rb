class DropAthletesTable < ActiveRecord::Migration
  def change
    drop_table :athletes
  end
end
