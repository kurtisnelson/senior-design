class TeamsController < ApplicationController
  before_action :set_team, only: [:show,:edit,:update, :destroy]
  def index
  	@teams = Team.all
  end

  def new
  	@team = Team.new
  end

  def show
  end

  def edit
  end
  
  def create
    @team = Team.new(team_params)
    params[:team][:user_ids].each do | id |
      if id.length > 0
        @team.users << User.find(id)
      end
    end
	  if @team.save
		  flash[:success] = "Saved Team"
		  redirect_to teams_path
	  else
		  flash[:error] = "Could not save team"
		  render action: "new"
	  end
  end
  
  def destroy
  	@team.destroy
	redirect_to teams_url, notice: 'Team was successfully destroyed'
  end	
	 
  def update
  	if @team.update(team_params)
      params[:team][:user_ids].each do | id |
        if id.length > 0
         @team.users << User.find(id)
        end
      end
		  redirect_to @team, notice: 'Team wasy successfully updated'
	else
	 	render action: "edit"	 
	end
  end
  private
  def set_team
  	@team = Team.find(params[:id])
  end
  
  def team_params
  	params.require(:team).permit(
		:name, :description, :user_ids, :users_id, :users, :user
	)
  end
  	  	
end
