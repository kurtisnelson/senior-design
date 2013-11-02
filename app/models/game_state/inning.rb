module GameState
  class Inning < State
    def initialize(game_id)
      super(game_id)
    end

    def next
      r.incr key(:inning)
      set_array key(:bases), [0,0,0,0]
    end

    def to_number
      r.get(key(:inning)).to_i / 2
    end

    def top?
      if(r.get(key(:inning)).to_i % 2 == 0)
        return true
      else
        return false
      end
    end

    def bottom?
      !top?
    end
  end
end
