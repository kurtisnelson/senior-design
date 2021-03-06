module GameState
  class Game < State
    attr_reader :date
    attr_reader :lineups, :inning
    attr_reader :away_score, :home_score
    attr_accessor :socket_id

    def initialize(id)
      super(id)
      @lineups = Lineups.new(id)
      @inning = Inning.new(id)
    end

    def single!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 1
      r.set(key(:last_to_bat), player_id)
      pusher 'single'
      sf = StatFactory.new id, @inning
      sf.single(player_id)
    end

    def double!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 2
      r.set(key(:last_to_bat), player_id)
      pusher 'double'
      sf = StatFactory.new id, @inning
      sf.double(player_id)
    end

    def triple!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 3
      r.set(key(:last_to_bat), player_id)
      pusher 'triple'
      sf = StatFactory.new id, @inning
      sf.triple(player_id)
    end

    def homerun!
      set(:balls, 0)
      set(:strikes, 0)
      player_id = lineups.active(@inning).to_base 4
      r.set(key(:last_to_bat), player_id)   
      run! @inning.top? ? 0 : 1
      pusher 'homerun'
      sf = StatFactory.new id, @inning
      sf.homerun(player_id)
    end

    def run! topOrBottom
      Rails.logger.info "RUNNGINGGG::::::#{topOrBottom}"
      if topOrBottom == 0
        Rails.logger.info "MORE AWAY SCORE!!!!"
        increment_away_score
      else
        Rails.logger.info "MORE HOME SCORE!!!!"
        increment_home_score
      end
      pusher 'run', top: topOrBottom
      sf = StatFactory.new id, @inning
      sf.rbi r.get(key(:last_to_bat))
      sf.homerun 0
    end

    def on_base base_id
      temp = bases[base_id - 1]
      pusher 'on_base', base_id: base_id
      if temp == nil
        return 0
      else
        return temp
      end
    end

    def player_on_base base_id #THIS IS WRONG, but ryan is lazy at 3am.
      User.find(on_base(base_id))
    end

    def bases
      get_int_array :bases
    end

    def at_bat
      lineups.active(@inning).next
    end

    def out! player_id
      if(player_id == at_bat)
        s = lineups.active(@inning).to_out
        r.set(key(:last_to_bat), player_id)
      else
        s = r.lrem key(:bases), 0, player_id
      end
      out
      pusher 'out', player_id: player_id
      sf = StatFactory.new id,@inning
      sf.strike_out s
    end

    def strikes
      get(:strikes).to_i
    end

    def strike!
      strikes = r.incr(key :strikes)
      self.out if strikes == 3
      pusher 'strike'
    end

    def strikes= num
      set(:strikes, num)
    end

    def balls
      get(:balls).to_i
    end

    def ball!
      balls = r.incr(key :balls)
      self.walk! if balls == 4
      pusher 'ball'
    end

    def balls= num
      set(:balls, num)
    end

    def walk!
      pusher 'walk' unless balls == 4 #this was an autowalk, don't push
      r.pipelined do
        set(:balls, 0)
        set(:strikes, 0)
      end
      player_id = lineups.active(@inning).to_base 1
      r.set(key(:last_to_bat), player_id)
      ##TODO(rfahsel3) Log a stat
    end

    def outs
      get(:outs).to_i
    end

    def outs= num
      set(:outs, num)
    end

    def out
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
      pusher 'next_inning'
    end

    def away_score!
      r.incr(key :away)
      pusher 'away_score'
    end

    def home_score!
      r.incr(key :home)
      pusher 'home_score'
    end

    def move! player_id, new_base, is_steal
      temp = bases
      if new_base == 2
        temp[1] = temp[0]
        temp[0] = 0
      elsif new_base == 3
        temp[2] = temp[1]
        temp[1] = 0
      elsif new_base == 4
        temp = [0,0,0]
        #TODO, score a run
        sf = StatFactory.new id,@inning
        sf.rbi player_id
      end
      set_array key(:bases), temp
      pusher 'move', {player_id: player_id, new_base: new_base, is_steal: is_steal == 1}
      if is_steal == 1
        sf = StatFactory.new id,@inning
        sf.steal player_id
      end
    end

    def increment_away_score
      r.incr(key(:away_score))
    end

    def away_score
      r.get(key(:away_score)).to_i
    end

    def increment_home_score
      r.incr(key(:home_score))
    end

    def home_score
       r.get(key(:home_score)).to_i
    end

    def expire
      @date = Time.now
      epoch = @date.to_i
      r.pipelined do
        lineups.set_expiration(epoch)
        inning.set_expiration(epoch)
        set_expiration(epoch)
      end
    end

    private
    def pusher(event, data = {})
      @socket_id ||= ""
      return if Rails.env == "test"
      Pusher.trigger_async('game_state_'+@id.to_s, event, data, {socket_id: @socket_id})
    end

    def set_expiration epoch
        r.expireat(key(:bases), epoch)
        r.expireat(key(:away), epoch)
        r.expireat(key(:home_score), epoch)
        r.expireat(key(:away_score), epoch)
        r.expireat(key(:home), epoch)
        r.expireat(key(:balls), epoch)
        r.expireat(key(:strikes), epoch)
        r.expireat(key(:outs), epoch)
    end
  end
end
