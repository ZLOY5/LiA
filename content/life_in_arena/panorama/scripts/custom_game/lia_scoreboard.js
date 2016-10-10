"use strict";

var g_ScoreboardHandle = null;
var visible;
var firstH = false;


function SetFlyoutScoreboardVisible( bVisible )
{
	visible = bVisible;
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", visible );
	if (!firstH)
	{
		firstH = true;
		GameEvents.SendCustomGameEventToServer( "apply_command_hint_hide", { "idPlayer" : Game.GetLocalPlayerID() } );
		//$.Msg( "                  firstH ", firstH );
	}
}


function OnUpdActionHide( dataHide )
{
	SetFlyoutScoreboardVisible( dataHide.visible );
	//$.Msg( "                  				OnUpdActionHide    " );
}

function ScheduledUpdate()
{
	OnUpdatePlayerData()
	$.Schedule(0.25,ScheduledUpdate)
	//$.Msg("ScheduledUpdateScoreboard")
}

function OnUpdatePlayerData( data )
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

(function()
{
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" )); // 
	
	//SetFlyoutScoreboardVisible( false );

	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
	CustomNetTables.SubscribeNetTableListener("lia_player_table",OnUpdatePlayerData)

	$.Schedule(0.25,ScheduledUpdate)

	GameEvents.Subscribe( "upd_action_hide",  OnUpdActionHide);
	OnUpdatePlayerData()
	//
	
})();