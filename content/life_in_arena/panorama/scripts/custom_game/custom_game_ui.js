"use strict";

Players.GetLumber = function(playerID) {
	var netTable = CustomNetTables.GetTableValue("lia_player_table", "Player"+playerID)
	if (typeof(netTable) == "object") {
		return netTable.lumber 
	}
	return 0
}

Players.IsReadyToRound = function(playerID) {
	var netTable = CustomNetTables.GetTableValue("lia_player_table", "Player"+playerID);
	if (typeof(netTable) == "object") {
		return netTable.readyToRound 
	}
	return false
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
		var playerInfo = Game.GetPlayerInfo(playerID)
		if (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_CONNECTED)
			n++;
	}
	return n
}