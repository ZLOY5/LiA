"use strict";

var _endScoreboardHandle;
var _containerPanel;

function OnUpdActionEnd( data )
{
	var allscore = 0;
	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}

	var containerPanel = _containerPanel
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( _endScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}

	var numS =0;
	var teamPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	//$.Msg(teamPlayers)
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	//$.Msg( "                  OnUpdActionEnd:	playersContainer ", playersContainer );
	if ( playersContainer )
	{
		for (var playerID of teamPlayers)
		{
			var customPlayerInfo = CustomNetTables.GetTableValue("lia_player_table", "Player"+playerID)
			
			if (customPlayerInfo.place <= 4)
				allscore = allscore + customPlayerInfo.rating*(0.6+0.1*customPlayerInfo.place)

			_ScoreboardUpdater_UpdatePlayerPanel( _endScoreboardHandle.scoreboardConfig, playersContainer, playerID, localPlayerTeamId)
		}	

		for (var playerID of teamPlayers)
		{
			//Чтобы все герои стали на свои места в таблице
			_ScoreboardUpdater_UpdatePlayerPanel( _endScoreboardHandle.scoreboardConfig, playersContainer, playerID, localPlayerTeamId)
		}
	}
	
	//
	

	var sec = Math.floor(Game.GetGameTime());
	var extraForTime = 0;
	//
	var winningTeamId = Game.GetGameWinner();
	//$.Msg( "                  winningTeamId ", winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if (winningTeamId === 3)
	{
		endScreenVictory.text = $.Localize( "#end_screen_lose" ) ;	
	}
	else
	{
		endScreenVictory.text = $.Localize( "#end_screen_victory" ) ;	
		if (3000-sec > 0)
			extraForTime  = (3000 - sec) * 1;
		if (extraForTime > 1500)
			extraForTime = 1500;


	}
	//
	allscore = allscore + extraForTime;
	//
	//var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.5;
	//var delay_per_panel = 1; // / teamInfoList.length;
	//for ( var teamInfo of teamInfoList )
	{
		
		teamPanel.SetHasClass( "team_endgame", false );
		var callback = function( panel )
		{
			//$.Msg( "                  OnUpdActionEnd:	function( panel ) ", panel );
			return function(){ panel.SetHasClass( "team_endgame", 1 ); }
		}( teamPanel );
		$.Schedule( delay, callback )
		//delay += delay_per_panel;
	}
	

	var endScreenAllScore = $( "#StatusScore" );
	//endScreenVictory.SetDialogVariable( "winning_team_score", $.Localize( "#LiaAllScore" + allscore ) );
	endScreenAllScore.text = $.Localize( "#LiaAllScore" ) + allscore.toFixed(0) ; 
	//
	var endScreenTime = $( "#StatusTime" );
	//
	var min = Math.floor(sec/60);	sec = sec - min*60;
	var hour = Math.floor(min/60);  min = min - hour*60;
	var strokaSec = "";
	var strokaMin = "";
	var strokaHour = "";
	if (hour<10)
		strokaHour = "0" + hour
	else
		strokaHour = hour;
	if (min<10)
		strokaMin = "0" + min
	else
		strokaMin = min;
	if (sec<10)
		strokaSec = "0" + sec
	else
		strokaSec = sec;
	//
	if (hour !== 0)
		endScreenTime.text = $.Localize( "#LiaTime" ) + strokaHour + ":" + strokaMin + ":" + strokaSec
	else
		endScreenTime.text = $.Localize( "#LiaTime" ) + strokaMin + ":" + strokaSec;
	
}

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_player.xml",
	};
	_containerPanel = $( "#TeamsContainer" );
	_endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, _containerPanel );

	
	

	if (Game.GetGameWinner() == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		GameUI.SetCameraDistance(0)
		GameUI.SetCameraPitchMin(10)
		GameUI.SetCameraPitchMax(10)
		GameUI.SetCameraLookAtPositionHeightOffset(300)
		GameUI.SetCameraYaw(47)
	}
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false );
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false);
	GameUI.SetRenderTopInsetOverride(0)

	OnUpdActionEnd()
})();
