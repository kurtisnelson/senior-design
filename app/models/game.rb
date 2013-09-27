class Game < ActiveRecord::Base
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team, class_name: "Team"
  has_many :stats

  def index
    @games = Game.all
  end

  def new
    @games = Game.all
    @game = Game.new
  end

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
    if(self.strike_count != 2)
      self.strike_count += 1
    else
      self.strike_count = 0
      self.ball_count = 0 
      self.out
    end
    self.save
  end

    def ball
    if(self.ball_count != 3)
      self.ball_count += 1
    else
      self.ball_count = 0
      self.strike_count = 0
    end
    self.save
  end

    def out
    if(self.out_count != 2)
      self.out_count += 1
    else
      self.out_count = 0
    end
    self.ball_count = 0
    self.strike_count = 0
    self.save
  end

  def away_point
    self.team_away_score += 1
    self.save
  end

  def home_point
    self.team_home_score += 1
    self.save
  end



end
