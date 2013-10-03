class GameState
  attr_reader :id
  attr_reader :date
  def initialize(id)
    @id = id
    @date = Game.find(id).start_date
  end

  def self.find id
    self.new(id)
  end

  def bases
    REDIS.get(key+"_bases")
  end

  def lineup
    REDIS.get(key+"_lineup")
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

  def set_expiration
    REDIS.expireat(key+"_lineup", @date.to_i)
    REDIS.expireat(key+"_bases", @date.to_i)
  end

  private
  def key
    "game_state_#{@id}"
  end
end
