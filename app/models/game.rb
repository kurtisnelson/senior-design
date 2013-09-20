class Game < ActiveRecord::Base
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team, class_name: "Team"

  def index
    @games = Game.all
  end


  def new
    @games = Game.all
    @game = Game.new
  end

  def in_progress?
    return true if self.start_datetime <= DateTime.now
    false
  end

  def start_datetime
    return nil unless start_date
    start_time ||= Time.now.beginning_of_day
    DateTime.new(start_date.year, start_date.month, start_date.day, start_time.hour, start_time.min, start_time.sec)
  end
end
