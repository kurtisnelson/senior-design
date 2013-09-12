class Game < ActiveRecord::Base
  def in_progress?
    return true if self.start_time <= Time.now
    false
  end
end
