class Stat < ActiveRecord::Base
	belongs_to :user
	belongs_to :game

  enumerate :category do
    value id: 0, name: "Single"
    value id: 1, name: "Double"
    value id: 2, name: "Triple"
    value id: 3, name: "Steal"
    value id: 4, name: "Homerun"
    value id: 5, name: "RBI"
    value id: 6, name: "Out"
    value id: 7, name: "Strike Out"
    value id: 8, name: "Base on Balls"
  end

  def self.avg(stats)
    at_bats = Stat.at_bats(stats)
    @avg = Stat.hits(stats).to_f / ( at_bats > 0 ? at_bats : 1 )
  end

  def self.homeruns(stats)
    @homeruns = Stat.look_for("Homerun", stats)
  end

  def self.homeruns_by_inning(stats,inning)
    @homeruns = Stat.look_for("Homerun", stats.where(inning: inning))
  end

  def self.rbi(stats)
    @rbi = Stat.look_for("RBI", stats)
  end 

  def self.obp(stats)
    denom = Stat.at_bats(stats) + Stat.look_for("Base on Balls", stats)
    @obp = (Stat.hits(stats).to_f + Stat.look_for("Base on Balls", stats)) / (denom > 0 ? denom : 1 )
  end

  def self.hits(stats)
    @hits = Stat.look_for("Single", stats) + Stat.look_for("Double", stats) + Stat.look_for("Triple", stats) + Stat.look_for("Homerun", stats) 
  end 

  def self.at_bats(stats)
    @at_bats =  Stat.hits(stats) + Stat.look_for("Out", stats)
  end

  private
    def self.look_for(value_in, stats)
      @value = 0
      stats.each do |stat|
        if stat.category(:name) == value_in
          @value = @value + 1
        end
      end
      @value
    end
end
