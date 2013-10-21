class ChangeStatsTypeToCategory < ActiveRecord::Migration
  def change
    rename_column :stats, :type, :category
  end
end
