json.game do
	json.extract! @game_state, :id, :bases, :lineup, :inactive_lineup, :strikes, :balls, :walks, :outs
end
json.players(@players) do |player|
	json.extract! player, :id, :name
end
