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
    @game.update_attributes(game_params)

    respond_to do |format|
      format.html {redirect_to @game}
      format.json {respond_with_bip(@game)}
    end
  end

  def score
    @game = Game.find(params[:game_id])
    if params[:score].present?
      respond_to do |format|
        @game.handle(params[:score])
        if @game.save
          format.html { redirect_to game_score_path(@game), notice: params[:score] }
          format.json { head :ok }
        else
          format.html { redirect_to game_score_path(@game), error: "Bad things happened" }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end
    @game = @game.decorate
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
