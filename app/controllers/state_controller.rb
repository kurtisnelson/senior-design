class StateController < ApplicationController
  before_action :set_game_state

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

  private
  def set_game_state
    @game_state = GameState.find(params[:id])
  end
end
