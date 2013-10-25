class StatFactory
  def initialize(game_id, inning)
    @game_id = game_id
    @inning = inning
  end

  def single(player)
    s = base_stat
    s.user_id = player
    s.category = "Single"
    s.save!
    s
  end


  private
  def base_stat
    Stat.new(game_id: @game_id, inning: @inning)
  end
end