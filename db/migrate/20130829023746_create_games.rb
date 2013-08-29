class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.datetime :start_time
      t.string :location

      t.timestamps
    end
  end
end
