class AddInningToStat < ActiveRecord::Migration
  def change
    add_column :stats, :inning, :integer
  end
end
