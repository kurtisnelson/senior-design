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

  def homerun
    @game_state.homerun!
    head :ok
  end

  def score
    @game_state.run!(params[:topOrBottom].to_i)
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

  def out
    @game_state.out!(params[:player_id])
    head :ok
  end

  def move
    @game_state.move! params[:player_id], params[:new_base], params[:is_steal]
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
    @game_state.lineups.home = lineups[:home].reverse
    @game_state.lineups.away = lineups[:away].reverse
    head :ok
  end

  private
  def set_game_state
    id = params[:id]
    id ||= params[:state_id]
    @game_state = GameState::Game.find(id)
    @game_state.socket_id = params[:socket_id]
  end
end
