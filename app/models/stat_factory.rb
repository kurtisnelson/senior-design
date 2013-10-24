class StatFactory
  def initialize(game, inning)
    @game = game
    @inning = inning
  end

  def single(player)
    s = base_stat
    s.user = player
    s.category = "Single"
    s.save!
  end


  private
  def base_stat
    Stat.new(game: @game, inning: @inning)
  end
end