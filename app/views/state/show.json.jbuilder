json.game do
	json.extract! @game_state, :id, :bases, :strikes, :balls, :walks, :outs

  json.lineups do
    json.home @game_state.lineups.home.to_a
    json.away @game_state.lineups.away.to_a
  end
end
json.players(@players) do |player|
	json.extract! player, :id, :name
end
