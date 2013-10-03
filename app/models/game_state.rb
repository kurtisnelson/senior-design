class GameState
  attr_reader :id
  attr_reader :date
  def initialize(id)
    @id = id
  end

  def self.find id
    self.new(id)
  end

  def bases
    get(:bases)
  end

  def lineup
    get(:lineup)
  end

  def out id
    REDIS.lrem(key+"_bases", 0, id)
  end

  def add_to_lineup id
    REDIS.lpush(key+"_lineup", obj)
  end

  def next_in_lineup
    REDIS.rpop(key+"_lineup")
  end

  def lineup_to_out
    REDIS.rpoplpush(key+"_lineup", key+"_lineup")
  end

  def lineup_to_bases
    REDIS.rpoplpush(key+"_lineup", key+"_bases")
  end

  def strikes
    get(:strikes).to_i
  end

  def strike
    strikes = REDIS.incr(key+"_strikes")
    self.out if strikes == 3
  end

  def balls
    get(:balls)
  end

  def ball
    balls = REDIS.incr(key+"_balls")
    self.walk if balls == 3
  end

  def walks
    get(:walks).to_i
  end

  def walk
    REDIS.pipelined do
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

  def out
    REDIS.pipelined do
      outs = REDIS.incr(key+"_outs")
      set(:balls, 0)
      set(:striks, 0)
    end
    next_inning if outs >= 3
  end

  def next_inning
    set(:outs, 0)
  end

  def away_point
    REDIS.incr(key+"_away")
  end

  def home_point
    REDIS.incr(key+"_home")
  end

  def set_expiration
    @date = Game.find(id).start_datetime
    REDIS.pipelined do
      REDIS.expireat(key+"_lineup", @date.to_i)
      REDIS.expireat(key+"_bases", @date.to_i)
    end
  end

  private
  def key
    "game_state_#{@id}"
  end

  def set attr, val
    REDIS.set(key+"_"+attr.to_s, val)
  end
  def get attr
    REDIS.get(key+"_"+attr.to_s)
  end
end
