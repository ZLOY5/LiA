"use strict";

var g_ScoreboardHandle = null;



function SetFlyoutScoreboardVisible( bVisible )
{
	if (bVisible != $.GetContextPanel().BHasClass("flyout_scoreboard_visible"))
		$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible",bVisible);
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

	OnUpdatePlayerData()
	//

	var func  = function() {
		$.Schedule(0.03,func)
		var scoreboard = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("scoreboard")
		$.DispatchEvent("DOTACustomUI_SetFlyoutScoreboardVisible", !scoreboard.BHasClass("ScoreboardClosed"))
	}
	func()

	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("courier").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CommonItems").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("QuickBuySlot8").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
})();