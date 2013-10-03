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
    r.lrem key(:bases), 0, id
  end

  def add_to_lineup id
    r.lpush key(:lineup), obj
  end

  def next_in_lineup
    r.rpop key(:lineup)
  end

  def lineup_to_out
    r.rpoplpush key(:lineup), key(:lineup)
  end

  def lineup_to_bases
    r.rpoplpush key(:lineup), key(:bases)
  end

  def strikes
    get(:strikes).to_i
  end

  def strike
    strikes = r.incr(key :strikes)
    self.out if strikes == 3
  end

  def balls
    get(:balls)
  end

  def ball
    balls = r.incr(key :balls)
    self.walk if balls == 3
  end

  def walks
    get(:walks).to_i
  end

  def walk
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

  def out
    r.pipelined do
      outs = r.incr(key :outs)
      set(:balls, 0)
      set(:striks, 0)
    end
    next_inning if outs >= 3
  end

  def next_inning
    set(:outs, 0)
  end

  def away_point
    r.incr(key :away)
  end

  def home_point
    r.incr(key :home)
  end

  def set_expiration
    @date = Game.find(id).start_datetime
    r.pipelined do
      r.expireat(key :lineup, @date.to_i)
      r.expireat(key :bases, @date.to_i)
    end
  end

  private
  def key name
    "#{@id}_#{name.to_s}"
  end

  def set attr, val
    r.set(key(attr), val)
  end
  def get attr
    r.get(key(attr).to_s)
  end

  def r
    @r ||= Redis::Namespace.new(:game_state, redis: REDIS)
    @r
  end
end
