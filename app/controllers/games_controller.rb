class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
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

  private
  def game_params
    params.require(:game).permit(
      :name, :start_time, :location
    )
  end
end