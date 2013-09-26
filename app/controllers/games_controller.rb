class GamesController < ApplicationController
  before_action :set_game, only: [:show,:edit,:update, :destroy]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def show
    @game = Game.find(params[:id]).decorate
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      flash[:success] = "Saved game"
      redirect_to games_path
    else
      flash[:error] = "Could not save game"
      render action: 'new'
    end
  end

  def update
    if @game.update(game_params)
      redirect_to @game, notice: "Game was updated"
    else
      flash[:error] = "Game was not updated"
      render action: "edit"
    end
  end

  def score
  	@game = Game.find(params[:game_id]).decorate
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(
      :name, :start_time, :start_date, :location, :away_team_id, :home_team_id
    )
  end
end
