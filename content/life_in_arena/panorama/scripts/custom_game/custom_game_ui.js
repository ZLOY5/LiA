"use strict";

Players.GetLumber = function(playerID) {
	return CustomNetTables.GetTableValue("lia_player_table", playerID).lumber
}