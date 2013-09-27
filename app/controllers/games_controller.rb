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
    @game = Game.find(params[:game_id])
    if params[:score].present?
      respond_to do |format|
        @game.send(params[:score]) ## HORRIBLE security hole, but lazy quick code
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

  def add_home_point
    @game = Game.find(params[:game_id])
    @game.team_home_score += 1
    if @game.save
      redirect_to game_score_path(@game)
    end
  end

  def add_away_point
    @game = Game.find(params[:game_id])
    @game.team_away_score += 1
    if @game.save
      redirect_to game_score_path(@game)
    end
  end

  def increment_strike
    @game = Game.find(params[:game_id])
    if (@game.strike_count != 2)
      @game.strike_count += 1
    else
      @game.strike_count = 0
      @game.ball_count = 0
      @game.out_count += 1
    end
    if @game.save
      redirect_to game_score_path(@game)
    end
  end

  def increment_ball
    @game = Game.find(params[:game_id])
    if (@game.ball_count != 3)
      @game.ball_count += 1
    else
      @game.ball_count = 0
      @game.strike_count = 0
    end
    if @game.save
      redirect_to game_score_path(@game)
    end
  end

  def increment_out
    @game = Game.find(params[:game_id])
    if (@game.out_count != 2)
      @game.out_count += 1
    else
      @game.out_count = 0
      @game.strike_count = 0
      @game.ball_count = 0
    end
    if @game.save
      redirect_to game_score_path(@game)
    end
  end

    def add_away_point
    @game = Game.find(params[:game_id])
    @game.team_away_score += 1
    if @game.save
      redirect_to game_score_path(@game)
    end
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
