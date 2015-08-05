"use strict";

var g_ScoreboardHandle = null;
var visible;

function AutoUpdateScoreboard()
{
	if (!visible)
		return;

	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );
    $.Schedule( 1, AutoUpdateScoreboard );
}

function UpdatePlayers()
{
	g_ScoreboardHandle.scoreboardConfig["updatePlayersCount"] = true;
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, visible );
}

function SetFlyoutScoreboardVisible( bVisible )
{
	visible = bVisible;
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", visible );
	if ( visible )
	{
		AutoUpdateScoreboard( bVisible );
	}
	else
	{
		ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, false );
	}
}

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/scoreboard/simple_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/scoreboard/simple_scoreboard_player.xml",
		"updatePlayersCount" : false,
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );

	SetFlyoutScoreboardVisible( false );

	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
	// Подписываемся на событие "Смена команды"
    GameEvents.Subscribe("player_team", UpdatePlayers);	
})();