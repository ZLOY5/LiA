function OnUpdatePlayerData(data) {
	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if (localPlayer) {
		localPlayerTeamId = localPlayer.player_team_id;
	}

	var containerPanel = $("#TeamsContainer");
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
	var teamPanel = containerPanel.FindChild(teamPanelName);
	if (teamPanel === null) {
		teamPanel = $.CreatePanel("Panel", containerPanel, teamPanelName);
		teamPanel.BLoadLayout(g_ScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}

	var teamPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
	var playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
	//$.Msg( "                  OnUpdAction:playersContainer ", playersContainer );
	if (playersContainer) {
		for (var playerID of teamPlayers) {
			_ScoreboardUpdater_UpdatePlayerPanel(
				g_ScoreboardHandle.scoreboardConfig,
				playersContainer,
				playerID,
				localPlayerTeamId,
			);
		}
	}

	return 0.5;
}

(function () {
	var scoreboardConfig = {
		teamXmlName: "file://{resources}/layout/custom_game/top_scoreboard/top_scoreboard_team.xml",
		playerXmlName: "file://{resources}/layout/custom_game/top_scoreboard/top_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, $("#TeamsContainer")); //

	//SetFlyoutScoreboardVisible( false );

	CustomNetTables.SubscribeNetTableListener("lia_player_table", OnUpdatePlayerData);

	$.Schedule(0.5, OnUpdatePlayerData);

	GameEvents.Subscribe("upd_action_hide", OnUpdActionHide);
	OnUpdatePlayerData();
})();
