class AddTeamIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :team, index: true
  end
end
