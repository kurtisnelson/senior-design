module GameState
  class Game < State
    attr_reader :date
    attr_reader :lineups, :inning

    def initialize(id)
      super(id)
      @lineups = Lineups.new(id)
      @inning = Inning.new(id)
    end

    def single!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_bases
      sf = StatFactory.new id, @inning
      sf.single(player_id)
    end

    def double!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_bases
      r.lpush(key(:bases), nil)
      sf = StatFactory.new id, @inning
      sf.double(player_id)
    end

    def triple!
      set(:balls, 0)
      set(:strikes, 0)
      lineups.active(@inning).to_bases
      r.lpush(key(:bases), nil)
      r.lpush(key(:bases), nil)
    end

    def on_base base_id
      r.lindex(key(:bases), base_id).to_i
    end

    def player_on_base base_id
      User.find(on_base(base_id))
    end

    def bases
      r.lrange(key(:bases), 0, -1).map {|i| i.to_i}
    end

    def at_bat
      lineups.active(@inning).next
    end

    def out player_id
      if(player_id == at_bat)
        lineups.active(@inning).to_out
      else
        r.lrem key(:bases), 0, player_id
      end
      out!
    end

    def strikes
      get(:strikes).to_i
    end

    def strike!
      strikes = r.incr(key :strikes)
      self.out! if strikes == 3
    end

    def strikes= num
      set(:strikes, num)
    end

    def balls
      get(:balls).to_i
    end

    def ball!
      balls = r.incr(key :balls)
      self.walk! if balls == 3
    end

    def balls= num
      set(:balls, num)
    end

    def walks
      get(:walks).to_i
    end

    def walk!
      r.pipelined do
        set(:balls, 0)
        set(:strikes, 0)
      end
    end

    def outs
      get(:outs).to_i
    end

    def outs= num
      set(:outs, num)
    end

    def out!
      r.pipelined do
        outs = r.incr(key :outs)
        set(:balls, 0)
        set(:strikes, 0)
      end
      next_inning! if outs >= 3
    end

    def next_inning!
      set(:outs, 0)
      r.del(key :bases)
    end

    def away_score!
      r.incr(key :away)
    end

    def home_score!
      r.incr(key :home)
    end

    def steal! player_id
      r.linsert(key(:bases), :before, player_id.to_s, nil)
    end

    def set_expiration
      @date = ::Game.find(id).start_datetime + 1.day
      epoch = @date.to_i
      r.pipelined do
        lineups.set_expiration(epoch)
        inning.set_expiration(epoch)
        self.set_expiration(epoch)
      end
    end

    private
    def set_expiration epoch
        r.expireat(key :bases, epoch)
        r.expireat(key :away, epoch)
        r.expireat(key :home, epoch)
        r.expireat(key :balls, epoch)
        r.expireat(key :strikes, epoch)
        r.expireat(key :outs, epoch)
    end
  end
end
