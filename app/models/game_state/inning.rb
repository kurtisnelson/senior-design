module GameState
  class Inning
    def initialize(game_id)
      @id = game_id.to_i
    end

    def top?
      true
    end

    def bottom?
      false
    end
  end
end
