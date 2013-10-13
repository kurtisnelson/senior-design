class GameState
  attr_reader :id
  attr_reader :date

  def initialize(id)
    @id = id.to_i
  end

  def self.find id
    self.new(id)
  end

  def single!
    set(:balls, 0)
    set(:strikes, 0)
    lineup_to_bases
  end

  def double!
    set(:balls, 0)
    set(:strikes, 0)
    r.lpush(key(:bases), 0)
    lineup_to_bases
  end

   def triple!
    set(:balls, 0)
    set(:strikes, 0)
    r.lpush(key(:bases), 0)
    r.lpush(key(:bases), 0)
    lineup_to_bases
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

  def lineup
    r.lrange(key(:lineup), 0, -1).map {|i| i.to_i}
  end

  def at_bat
    r.lrange(key(:bases), 0, 0).first.to_i
  end

  def out player_id
    r.lrem key(:bases), 0, player_id
    r.incr(key :outs)
  end

  def add_to_lineup id
    r.lpush key(:lineup), id
  end

  def next_in_lineup
    r.rpop(key(:lineup)).to_i
  end

  def lineup_to_out
    r.rpoplpush(key(:lineup), key(:lineup)).to_i
  end

  def lineup_to_bases
    r.rpoplpush(key(:lineup), key(:bases)).to_i
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
    r.del(key :lineup)
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
    @date = Game.find(id).start_datetime + 1.day
    r.pipelined do
      r.expireat(key :lineup, @date.to_i)
      r.expireat(key :bases, @date.to_i)
      r.expireat(key :away, @date.to_i)
      r.expireat(key :home, @date.to_i)
      r.expireat(key :balls, @date.to_i)
      r.expireat(key :strikes, @date.to_i)
      r.expireat(key :outs, @date.to_i)
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
