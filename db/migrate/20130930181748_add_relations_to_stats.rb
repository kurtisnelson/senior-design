class AddRelationsToStats < ActiveRecord::Migration
  def change
    add_reference :stats, :user, index: true
    add_reference :stats, :team, index: true
  end
end
