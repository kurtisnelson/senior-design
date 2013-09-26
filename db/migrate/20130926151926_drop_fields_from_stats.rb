class DropFieldsFromStats < ActiveRecord::Migration
  def change
  		remove_column :stats, :at_bats, :integer
  		remove_column :stats, :hits, :integer
  		remove_column :stats, :rbis, :integer
  		remove_column :stats, :singles, :integer
  		remove_column :stats, :doubles, :integer
  		remove_column :stats, :triples, :integer
  		remove_column :stats, :home_runs, :integer
  		remove_column :stats, :strike_outs, :integer
  		remove_column :stats, :walks, :integer
  end
end
