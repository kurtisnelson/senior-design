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

  def out(player)
    s = base_stat
    s.user_id = player
    s.category = 6
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

  def homerun(player)
    s = base_stat
    s.user_id = player
    s.category = 4
    s.save!
    s
  end  

  def steal(player)
    s = base_stat
    s.user_id = player
    s.category = 3
    s.save!
    s
  end

  def rbi(player)
    s = base_stat
    s.user_id = player
    s.category = 5
    s.save!
    s
  end

  def base_on_balls(player)
    s = base_stat
    s.user_id = player
    s.category = 8
    s.save!
    s
  end

  private
  def base_stat
    Stat.new(game_id: @game_id, inning: @inning.to_number)
  end
end