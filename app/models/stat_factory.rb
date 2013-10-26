##Look at stat.rb for enum declarations

class StatFactory
  def initialize(game_id, inning)
    @game_id = game_id
    @inning = inning
  end

  def single(player)
    s = base_stat
    s.user_id = player
    s.category = 0
    s.save!
    s
  end

  def double(player)
    s = base_stat
    s.user_id = player
    s.category = 1
    s.save!
    s
  end
  
  def triple(player)
    s = base_stat
    s.user_id = player
    s.category = 2
    s.save!
    s
  end

  def strike_out(player)
    s = base_stat
    s.user_id = player
    s.category = 7
    s.save!
    s
  end

  private
  def base_stat
    Stat.new(game_id: @game_id, inning: @inning)
  end
end