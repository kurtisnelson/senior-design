class GamesController < ApplicationController
  def index
    @games = GameDecorator.decorate_collection Game.all
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

  def score
  	@game = Game.find(params[:game_id])
  end

  private
  def game_params
    params.require(:game).permit(
      :name, :start_time, :location
    )
  end
end
