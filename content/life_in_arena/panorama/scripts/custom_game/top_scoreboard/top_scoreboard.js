function ScheduledUpdate()
{
	OnUpdatePlayerData()
	$.Schedule(0.25,ScheduledUpdate)
}

function OnUpdatePlayerData()
{

	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}

	var containerPanel = $( "#TeamsContainer")
	var teamPanelName = "_dynamic_team_" + DOTATeam_t.DOTA_TEAM_GOODGUYS;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( g_ScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}

	
	var teamPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	//$.Msg( "                  OnUpdAction:playersContainer ", playersContainer );
	if ( playersContainer )
	{
		
		for (var playerID of teamPlayers) {
			
			_ScoreboardUpdater_UpdatePlayerPanel( g_ScoreboardHandle.scoreboardConfig, playersContainer, playerID, localPlayerTeamId ); 
		
		}
		
	}
}


function ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, scoreboardPanel )
{
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if ( typeof(scoreboardConfig.shouldSort) === 'undefined')
	{
		// default to true
		scoreboardConfig.shouldSort = false;
	}
	//$.Msg( "                  ScoreboardUpdater_InitializeScoreboard: ", scoreboardConfig );
	//_ScoreboardUpdater_UpdateAllPlayers( scoreboardConfig, scoreboardPanel );
	
	return { "scoreboardConfig": scoreboardConfig, "scoreboardPanel" : scoreboardPanel }
}


(function()
{
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/top_scoreboard/top_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/top_scoreboard/top_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" )); // 
	
	//SetFlyoutScoreboardVisible( false );

	CustomNetTables.SubscribeNetTableListener("lia_player_table",OnUpdatePlayerData)

	$.Schedule(0.25,ScheduledUpdate)

	OnUpdatePlayerData()
	
})();