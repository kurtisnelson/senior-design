class Team < ActiveRecord::Base
	has_many :games
	has_many :players, dependent: :delete_all
	has_many :users, through: :players
	has_many :stats, through: :users

	def add_player user_id
    @player = Player.new()
    @player.team_id = self.id
    @player.user_id = user_id
    @player.player_number = nil
    @player.save!
  end
end
