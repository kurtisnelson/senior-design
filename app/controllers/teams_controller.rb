class TeamsController < ApplicationController
  before_action :set_team, only: [:show,:edit,:update, :destroy]
  
  autocomplete :user, :name
  autocomplete :team, :name

  def index
  	@teams = Team.all
    @team = Team.new
  end

  def new
  	@team = Team.new
  end

  def show
    @players = @team.players
  end

  def edit
  end
  
  def create
    @team = Team.new(team_params)
    if @team.save
      flash.now[:success] = "Team was successfully created."
    else
      flash.now[:error] = "Error in creating team."
    end

    respond_to do |format|
      format.html { redirect_to teams_path, notice: 'Team was successfully created.'}
      format.js   
    end
  end
  
  def destroy
  	@team.destroy

    respond_to do |format|
      format.html { redirect_to teams_path, notice: "Team was successfully deleted." }
      format.js  
    end
  end	
	 
  def update
    if @team.update(team_params)
      flash.now[:success] = "Team was successfully updated."
    else
      flash.now[:error] = "Error in updating team."
    end

    respond_to do |format|
      format.html { redirect_to @team }
      format.js   
      format.json { respond_with_bip(@team)}
    end
  end

  def add_player
    @player = Player.new()
    @player.team_id = params[:game_id]
    @player.user_id = params[:user_id]
    @player.player_number = -1
    @player.save
  end

  def get_available_users
    User.all
  end

  private
  def set_team
  	@team = Team.find(params[:id])
  end
  
  def team_params
  	params.require(:team).permit(
  		:name, :description, :user_ids => []
  	)
  end
  	  	
end
