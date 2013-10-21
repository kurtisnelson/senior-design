class PlayersController < ApplicationController
  def new
    @player = Player.new
    @player.team_id = params[:team_id]
    @player.save

    respond_to do |format|
      format.js
    end
  end

  def show
    @player = Player.find(params[:id])
    @team = Team.find(params[:team_id])
  end

	def edit
		respond_to do |format|
      format.html { redirect_to team_player_path}
      format.js
    end
	end

	def create
		@Player.new(player_params)
	end

  def add
    @player = Player.new
    @player.team_id = params[:team_id]
    @player.save

    respond_to do |format|
      format.json { respond_with_bip(@player) }
    end
  end

  def update_jersey_number
    @player = Player.find(params[:player_id])
    @player.player_number = params[:player][:player_number].to_i
    @player.save

    respond_to do |format|
      format.json { respond_with_bip(@player) }
    end
  end

	private
	def player_params
		params.require(:player).permit(
			:team_id, :user_id, :player_number
		)
	end
end
