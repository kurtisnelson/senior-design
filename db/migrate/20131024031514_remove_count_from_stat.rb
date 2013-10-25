class RemoveCountFromStat < ActiveRecord::Migration
  def change
    remove_column :stats, :count
  end
end
