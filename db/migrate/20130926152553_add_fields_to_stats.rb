class AddFieldsToStats < ActiveRecord::Migration
  def change
  	add_column :stats, :type, :string
  	add_column :stats, :count, :integer
  end
end
