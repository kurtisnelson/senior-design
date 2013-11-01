module GameState
  class Game < State
    attr_reader :date
    attr_reader :lineups, :inning
    attr_reader :away_score, :home_score

    def initialize(id)
      super(id)
      @lineups = Lineups.new(id)
      @inning = Inning.new(id)
      @home_score = 0
      @away_score = 0
    end

    def single!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 1
      r.set(key(:last_to_bat), player_id)      
      sf = StatFactory.new id, @inning
      sf.single(player_id)
    end

    def double!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 2
      r.set(key(:last_to_bat), player_id)      
      sf = StatFactory.new id, @inning
      sf.double(player_id)
    end

    def triple!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 3
      r.set(key(:last_to_bat), player_id)
      sf = StatFactory.new id, @inning
      sf.triple(player_id)
    end

    def homerun!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 4
      r.set(key(:last_to_bat), player_id)      
      run! @inning.top?
      sf = StatFactory.new id, @inning
      sf.homerun(player_id)     
    end
   
    def run! topOrBottom
      if topOrBottom
        @away_score+=1
      else
        @home_score+=1
      end
      sf = StatFactory.new id, @inning
      sf.rbi r.get(key(:last_to_bat))
    end

    def on_base base_id
      temp = r.get(key(:bases))
      if base_id == 1
        ret_val = JSON.parse(temp)[0]
      elsif base_id == 2
        ret_val = JSON.parse(temp)[1]
      elsif base_id == 3
        ret_val = JSON.parse(temp)[2]
      end
      ret_val
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
        s = lineups.active(@inning).to_out
        r.set(key(:last_to_bat), player_id)
      else
        s = r.lrem key(:bases), 0, player_id
      end
      out!
      sf = StatFactory.new id,@inning
      sf.strike_out s
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
      @inning.next
    end

    def away_score!
      r.incr(key :away)
    end

    def home_score!
      r.incr(key :home)
    end

    def steal! player_id, new_base
      temp = r.get(key(:bases))
      temp = JSON.parse(temp)
      if new_base == 2
        temp[1] = temp[0]
        temp[0] = 0
      elsif new_base == 3
        temp[2] = temp[1]
        temp[1] = 0
      elsif new_base == 4
        temp = [0,0,0]
        #TODO, score a run
      end
      r.set(key(:bases),temp.to_json)
      sf = StatFactory.new id,@inning
      sf.steal player_id   

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
