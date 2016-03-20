"use strict";

Players.GetLumber = function(playerID) {
	return CustomNetTables.GetTableValue("lia_player_table", playerID).lumber || 0
}

Players.IsReadyToRound = function(playerID) {
	return CustomNetTables.GetTableValue("lia_player_table", playerID).readyToRound || false
}

Players.GetNumPlayersReadyToRound = function() {
	var n = 0
	var pIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
	for (var playerID of pIds) {
		if (Players.IsReadyToRound(playerID)) 
			n++;
	}
	return n
}

Players.GetNumPlayers = function() {
	var n = 0
	var pIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
	for (var playerID of pIds) {
		n++;
	}
	return n
}