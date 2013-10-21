module GameState
  class Lineups
    attr_accessor :home, :away

    def initialize id
      @id = id
      @home = Lineup.new(@id, :home)
      @away = Lineup.new(@id, :away)
    end

    def to_a
      @home.to_a + @away.to_a
    end

    def active inning
      return away if inning.top?
      home
    end

    def set_expiration epoch
      away.set_expiration epoch
      home.set_expiration epoch
    end
  end
end
