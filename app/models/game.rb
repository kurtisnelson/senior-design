class Game < ActiveRecord::Base
	attr_accessible :name, :start_time, :location
end
