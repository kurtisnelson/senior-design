class PlayerController < ApplicationController
	def create
		@Player.new(player_params)
	end

	private
	def player_params
		params.require(:player).permit(
			:team_id, :user_id, :player_number
		)
	end
end
