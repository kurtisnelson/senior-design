json.game do
	json.extract! @game_state, :id, :bases, :strikes, :balls, :outs, :home_score, :away_score
	json.home_id @game.home_team.try(:id)
	json.away_id @game.away_team.try(:id)
	json.inning do
		json.number @game_state.inning.to_number
		json.top @game_state.inning.top?
	end

  json.lineups do
    json.home @game_state.lineups.home.to_a.reverse
    json.away @game_state.lineups.away.to_a.reverse
  end
end
