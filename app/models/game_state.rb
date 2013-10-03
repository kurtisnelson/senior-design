class GameState
  attr_reader :id
  def initialize(id)
    @id = id
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

  private
  def key
    "game_state_#{@id}"
  end
end
