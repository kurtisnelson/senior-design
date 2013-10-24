module GameState
  def self.find id
    GameState::Game.new(id)
  end

  class State
    attr_reader :id
    def initialize(id)
      @id = id.to_i
      @game = ::Game.find(@id)
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
      r.llen(key(attr))
    end

    def get_int_array attr
      r.lrange(key(attr), 0, -1).map {|i| i.to_i}
    end

    def set_expiration
      raise "no expiration method"
    end

    def r
      State.r
    end

    def State.r
      @r ||= Redis::Namespace.new(:game_state, redis: REDIS)
      @r
    end
  end
end