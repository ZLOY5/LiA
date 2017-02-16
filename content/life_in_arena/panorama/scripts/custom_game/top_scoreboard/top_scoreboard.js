function ScheduledUpdate()
{
	$.Schedule(0.03,ScheduledUpdate)
	OnUpdatePlayerData()
	
}

function UpdatePlayerPanel(playerID) {
	var playersContainer = $.GetContextPanel().FindChildTraverse( "PlayersContainer" );
	var playerPanel = playersContainer.FindChildTraverse("player"+playerID)

	var customPlayerInfo = CustomNetTables.GetTableValue("lia_player_table", "Player"+playerID)

	if (playerPanel == null) {
		var playerPanel = $.CreatePanel( "Panel",  playersContainer, "player"+playerID );
		playerPanel.BLoadLayout("file://{resources}/layout/custom_game/top_scoreboard/top_scoreboard_player.xml", false, false)
		playerPanel.SetAttributeInt("player_id", playerID)
	}

	playerPanel.AddClass("Slot"+playerID)

	var heroImage = playerPanel.FindChildTraverse("HeroImage")
	heroImage.heroname = Players.GetPlayerSelectedHero(playerID)

	var hero = Players.GetPlayerHeroEntityIndex(playerID)

	playerPanel.FindChildTraverse("HealthBar").max = 100
	playerPanel.FindChildTraverse("HealthBar").value = Entities.GetHealthPercent(hero)
	playerPanel.FindChildTraverse("ManaBar").value = Entities.GetMana(hero)/Entities.GetMaxMana(hero)

	playerPanel.SetHasClass("AltPressed",GameUI.IsAltDown() )
	playerPanel.SetHasClass("Dead", !Entities.IsAlive(hero) )

	if (customPlayerInfo != null) {
		var panel = playersContainer.GetChild(customPlayerInfo.place-1)
			if (panel !== null) 
				playersContainer.MoveChildBefore(playerPanel,playersContainer.GetChild(customPlayerInfo.place-1))
			playerPanel.style.zIndex = -customPlayerInfo.place

		playerPanel.SetHasClass( "ReadyToRound", customPlayerInfo.readyToRound );
	}



	ultStateOrTime = Game.GetPlayerUltimateStateOrTime(playerID)

	playerPanel.SetHasClass( "UltLearned", ( !(ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED) ) );
	playerPanel.SetHasClass( "UltReady", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY ) );
	playerPanel.SetHasClass( "UltReadyNoMana", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA) );
	playerPanel.SetHasClass( "UltOnCooldown", ( ultStateOrTime > 0 ) );

	var playerInfo = Game.GetPlayerInfo(playerID)
	playerPanel.SetHasClass( "Disconnected", ( (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED) || (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED) ) );
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
			
			UpdatePlayerPanel(playerID); 
		
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