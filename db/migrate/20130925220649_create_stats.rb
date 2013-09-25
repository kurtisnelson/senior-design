class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :at_bats
      t.integer :hits
      t.integer :rbis
      t.integer :singles
      t.integer :doubles
      t.integer :triples
      t.integer :home_runs
      t.integer :strike_outs
      t.integer :walks

      t.timestamps
    end
  end
end
