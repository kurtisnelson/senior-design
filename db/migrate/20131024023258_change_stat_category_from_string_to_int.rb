class ChangeStatCategoryFromStringToInt < ActiveRecord::Migration
  def change
    remove_column :stats, :category
    add_column :stats,:category,:integer
  end
end
