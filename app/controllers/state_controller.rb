class StateController < ApplicationController
  before_action :set_game_state

  def show
    @players = User.where(id: @game_state.lineup) + User.where(id: @game_state.bases)
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

  private
  def set_game_state
    id = params[:id]
    id ||= params[:state_id]
    @game_state = GameState.find(id)
  end
end
