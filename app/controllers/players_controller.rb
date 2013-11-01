class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def show
    @player = Player.find(params[:id])
    @team = Team.find(@player.team_id)
  end

  def index
    @users = User.where(id: Player.all.pluck(:id)).order(:name)
  end

	def edit
		respond_to do |format|
      format.html { redirect_to team_player_path}
      format.js
    end
	end

	def create
    @user = User.where(:name => params[:player][:user][:name]).first
    @team = Team.find(params[:team_id])

    if @user != nil
      @player = Player.new
      @player.team_id = params[:team_id]
      @player.user_id = @user.id
      @player.save
      flash[:success] = "Player added to team."
    else
      flash[:error] = "User does not exist."
    end
    respond_to do |format|
      format.html { redirect_to Team.find(params[:team_id]) }
      format.js
    end
    
	end

  def add
    @player = Player.new
    @player.team_id = params[:team_id]
    @player.save

    respond_to do |format|
      format.json { respond_with_bip(@player) }
    end
  end

  def destroy
    @player = Player.find(params[:player_id])
    @player.destroy
    redirect_to Team.find(params[:team_id])
  end

  def update_jersey_number
    @player = Player.find(params[:player_id])
    @player.player_number = params[:player][:player_number].to_i
    @player.save

    respond_to do |format|
      format.json { respond_with_bip(@player) }
    end
  end

  def new_user
    @user = User.create(user_params)
    @player = Player.new
    @player.user_id = @user.id
    @player.save
    redirect_to players_path
  end

	private
	def player_params
		params.require(:player).permit(
			:team_id, :user_id, :player_number
		)
	end

  def user_params
    params[:player].require(:user).permit(
      :name, :email
    )
  end
end
