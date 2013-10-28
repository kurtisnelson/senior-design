json.players(@players) do |player|
	json.user_id player.user_id
	json.name player.name
	json.number player.player_number
end