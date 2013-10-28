class Game < ActiveRecord::Base
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team, class_name: "Team"
  has_many :stats

  EVENTS = ["strike", "ball", "walk", "out", "away_point", "home_point"]

  def players
    away_team.players + home_team.players
  end

  def in_progress?
    return true if self.start_datetime && self.start_datetime <= DateTime.now
    false
  end

  def away_lineup
    vl = read_attribute(:away_lineup)
    return [] unless vl
    vl.split(',')
  end
  def away_lineup= lineup
    write_attribute(:away_lineup, lineup.join(','))
  end

  def home_lineup
    hl = read_attribute(:home_lineup)
    return [] unless hl
    hl.split(',')
  end
  def home_lineup= lineup
    write_attribute(:home_lineup, lineup.join(','))
  end

  def start_datetime
    return nil unless start_date
    start_time ||= Time.now.beginning_of_day
    DateTime.new(start_date.year, start_date.month, start_date.day, start_time.hour, start_time.min, start_time.sec)
  end

  def handle event
    raise "Invalid event" unless EVENTS.include? event
    GameState.new(self.id).send(event)
  end
end
