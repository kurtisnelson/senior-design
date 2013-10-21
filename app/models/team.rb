class Team < ActiveRecord::Base
	has_many :away_games, :class_name => "Game", foreign_key: "away_team_id"
  has_many :home_games, :class_name => "Game", foreign_key: "home_team_id"
	has_many :players, dependent: :delete_all
	has_many :users, through: :players
	has_many :stats, through: :users

  def games
      self.away_games + self.home_games
  end

  def available_players
    User.where.not(id: self.users)
  end

	def add_player 
    @player = Player.new()
    @player.team_id = self.id
    @player.player_number = nil
    @player.save
    @player
  end
end
