class Team < ActiveRecord::Base
	has_many :games
    has_and_belongs_to_many :users
    has_many :stats, through: :users
end
