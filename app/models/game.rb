class Game < ActiveRecord::Base
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team, class_name: "Team"
  has_many :stats

  def in_progress?
    return true if self.start_datetime && self.start_datetime <= DateTime.now
    false
  end

  def start_datetime
    return nil unless start_date
    start_time ||= Time.now.beginning_of_day
    DateTime.new(start_date.year, start_date.month, start_date.day, start_time.hour, start_time.min, start_time.sec)
  end

  def strike
    self.strike_count += 1
    self.out if strike_count == 3
  end

  def ball
    self.ball_count += 1
    self.walk if ball_count == 3
  end

  def walk
    self.ball_count = 0
    self.strike_count = 0
  end

  def out
    self.out_count += 1
    self.ball_count = 0
    self.strike_count = 0
    next_inning if self.out_count >= 3
  end

  def next_inning
    self.out_count = 0
  end

  def away_point
    self.team_away_score += 1
  end

  def home_point
    self.team_home_score += 1
  end
end
