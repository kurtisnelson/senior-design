class Game < ActiveRecord::Base
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team, class_name: "Team"

  def in_progress?
    return true if self.start_time <= Time.now
    false
  end
end
