class StateController < ApplicationController
  before_action :set_game_state

  def show
    @game = @game_state.game
  end

  def single
    @game_state.single!
    head :ok
  end

  def double
    @game_state.double!
    head :ok
  end

  def triple
    @game_state.triple!
    head :ok
  end

  def ball
    @game_state.ball!
    head :ok
  end

  def steal
    @game_state.steal!(params[:player_id])
    head :ok
  end

  def strike
    @game_state.strike!
    head :ok
  end

  def next_inning
    @game_state.next_inning!
    head :ok
  end

  def start_game
    #raise "already started" unless @game_state.inning.to_number < 1
    @game_state.next_inning!
    @game_state.next_inning!
    head :ok
  end

  def update
    lineups = params[:lineup]
    @game_state.lineups.home = lineups[:home]
    @game_state.lineups.away = lineups[:away]
    head :ok
  end

  private
  def set_game_state
    id = params[:id]
    id ||= params[:state_id]
    @game_state = GameState::Game.find(id)
  end
end
