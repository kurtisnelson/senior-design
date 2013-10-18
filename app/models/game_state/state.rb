module GameState
  def self.find id
    GameState::Game.new(id)
  end

  class State
    attr_reader :id
    def initialize(id)
      @id = id.to_i
    end

    def self.find id
      self.new(id)
    end

    def key name
      "#{@id}_#{name.to_s}"
    end

    def set attr, val
      r.set(key(attr), val)
    end

    def get attr
      r.get(key(attr).to_s)
    end

    def llength attr
      r.llen(key(attr)).to_i
    end

    def r
      @r ||= Redis::Namespace.new(:game_state, redis: REDIS)
      @r
    end
  end
end
