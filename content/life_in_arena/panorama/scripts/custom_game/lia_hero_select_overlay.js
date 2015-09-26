"use strict";

function OnUpdateHeroSelection()
{
	for ( var playerId of Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS) )
	{
		UpdatePlayer( playerId );
	}
}


function UpdatePlayer( playerId )
{
	var playerContainer = $( "#HeroSelectPlayersContainer").FindChild("PlayersContainer");
	var playerPanelName = "player_" + playerId;
	var playerPanel = playerContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Image", playerContainer, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/lia_hero_select_overlay_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );
		$.CreatePanel( "Panel", playerContainer, "Spacer" );
	}

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	var playerPortrait = playerPanel.FindChildInLayoutFile( "PlayerPortrait" );

	var playerGradient = playerPanel.FindChildInLayoutFile( "PlayerGradient" );
		if ( playerGradient && GameUI.CustomUIConfig().players_color )
		{
			var playerColor = GameUI.CustomUIConfig().players_color[ playerId ];
			playerColor = playerColor.replace( ";", "" );
			var gradientText = 'gradient( linear, 0% 0%, 0% 140%, from( #00000000 ), to( ' + playerColor + 'FF ) );';
//			$.Msg( gradientText );
			playerGradient.style.backgroundColor = gradientText;
		}
	
	if ( playerId == localPlayerInfo.player_id )
	{
		playerPanel.AddClass( "is_local_player" );
	}

	if ( playerInfo.player_selected_hero !== "" )
	{
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		playerPanel.SetHasClass( "hero_selected", true );
		playerPanel.SetHasClass( "hero_highlighted", false );
	}
	else if ( playerInfo.possible_hero_selection !== "" && ( playerInfo.player_team_id == localPlayerTeamId ) )
	{
		playerPortrait.SetImage( "file://{images}/heroes/npc_dota_hero_" + playerInfo.possible_hero_selection + ".png" );
		playerPanel.SetHasClass( "hero_selected", false );
		playerPanel.SetHasClass( "hero_highlighted", true );
	}
	else
	{
		playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
	}

	playerPortrait.SetHasClass( "local_player_team", playerId == Game.GetLocalPlayerID())

	var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
	playerName.text = playerInfo.player_name;
	//playerName.style.textAlign = "center";

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
}

function UpdateTimer()
{
	var gameTime = Game.GetGameTime();
	var transitionTime = Game.GetStateTransitionTime();

	var timerValue = Math.max( 0, Math.floor( transitionTime - gameTime ) );
	
	if ( Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION ) )
	{
		timerValue = 0;
	}
	$("#TimerPanel").SetDialogVariableInt( "timer_seconds", timerValue );

	$.Schedule( 0.1, UpdateTimer );
}

(function()
{
	var localPlayerTeamId = Game.GetLocalPlayerInfo().player_team_id;
	var first = true;
	var container = $("#HeroSelectPlayersContainer");
	$.CreatePanel( "Panel", container, "EndSpacer" );
	var playersContainer = $.CreatePanel( "Panel", container, "PlayersContainer" );
	
	var timerPanel = $.CreatePanel( "Panel", playersContainer, "TimerPanel" );
	timerPanel.BLoadLayout( "file://{resources}/layout/custom_game/lia_hero_select_overlay_timer.xml", false, false );
	
	OnUpdateHeroSelection()

	$.CreatePanel( "Panel", container, "EndSpacer" );

	GameEvents.Subscribe( "dota_player_hero_selection_dirty", OnUpdateHeroSelection );
	GameEvents.Subscribe( "dota_player_update_hero_selection", OnUpdateHeroSelection );

	UpdateTimer();
})();

