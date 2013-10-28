class Player < ActiveRecord::Base
	belongs_to :team
	belongs_to :user

	def name
		user.name
	end
end
