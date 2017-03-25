"use strict";

function OnUpdateHeroSelection()
{
	for ( var playerId of Game.GetAllPlayerIDs() )
	{
		if (!(Players.IsSpectator(playerId)))
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
		playerPanel = $.CreatePanel( "Panel", playerContainer, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/hero_picking_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );
		playerPanel.AddClass( "Slot"+playerId)
		$.CreatePanel( "Panel", playerContainer, "Spacer" );
	}

	var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
	playerName.text = Players.GetPlayerName( playerId )

	if ( playerId == Players.GetLocalPlayer() )
	{
		playerPanel.AddClass( "IsLocalPlayer" );	
	}

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;
	
	//$.Msg(playerInfo)

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	var playerPortrait = playerPanel.FindChildInLayoutFile( "HeroImage" );

	playerPanel.AddClass( "PlayerInControl" );
	


	var heroName = playerPanel.FindChildInLayoutFile( "HeroName" );

	if ( playerInfo.player_selected_hero !== "" )
	{
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		playerPanel.SetHasClass( "HeroPickTentative", false );
		heroName.text = $.Localize("#"+playerInfo.player_selected_hero)

		playerPortrait.SetPanelEvent("onmouseover", function() { playerPanel.ToggleClass("ShowHeroName") })
		playerPortrait.SetPanelEvent("onmouseout", function() { playerPanel.ToggleClass("ShowHeroName") })	

	}
	else if ( playerInfo.possible_hero_selection !== "" && ( playerInfo.player_team_id == localPlayerTeamId ) )
	{
		playerPortrait.SetImage( "file://{images}/heroes/npc_dota_hero_" + playerInfo.possible_hero_selection + ".png" );
		playerPanel.SetHasClass( "HeroPickTentative", true );
		heroName.text = $.Localize("#npc_dota_hero_"+playerInfo.possible_hero_selection)

		playerPortrait.SetPanelEvent("onmouseover", function() { playerPanel.ToggleClass("ShowHeroName") })
		playerPortrait.SetPanelEvent("onmouseout", function() { playerPanel.ToggleClass("ShowHeroName") })
		
	}




	if ( playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_CONNECTED ) {
		playerPanel.SetHasClass("PlayerConnecting", false)
		playerPanel.SetHasClass("PlayerConnected", true)
		playerPanel.SetHasClass("PlayerFailedToConnect", false)
		playerPanel.SetHasClass("Disconnected", false)
	}
	else if ( playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED ) {
		playerPanel.SetHasClass("PlayerConnecting", false)
		playerPanel.SetHasClass("PlayerConnected", false)
		playerPanel.SetHasClass("PlayerFailedToConnect", false)
		playerPanel.SetHasClass("Disconnected", true)
	}
	else if ( playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED ) {
		playerPanel.SetHasClass("PlayerConnecting", false)
		playerPanel.SetHasClass("PlayerConnected", false)
		playerPanel.SetHasClass("PlayerFailedToConnect", true)
		playerPanel.SetHasClass("Disconnected", false)
	}
	else if ( playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_LOADING ) {
		playerPanel.SetHasClass("PlayerConnecting", true)
		playerPanel.SetHasClass("PlayerConnected", false)
		playerPanel.SetHasClass("PlayerFailedToConnect", false)
		playerPanel.SetHasClass("Disconnected", false)
	}
	
	if (playerInfo.player_steamid != 90071996842377222) { 
		playerName.SetPanelEvent("onmouseover", function() { 
			$.DispatchEvent("DOTAShowProfileCardTooltip", playerName, playerInfo.player_steamid, false) 
		})
		playerName.SetPanelEvent("onmouseout", function() { $.DispatchEvent("DOTAHideProfileCardTooltip") })
	}
}


(function()
{
	var container = $("#HeroSelectPlayersContainer");
	var playersContainer = $.CreatePanel( "Panel", container, "PlayersContainer" );
	
	OnUpdateHeroSelection()

	
	GameEvents.Subscribe( "dota_player_hero_selection_dirty", OnUpdateHeroSelection );
	GameEvents.Subscribe( "dota_player_update_hero_selection", OnUpdateHeroSelection );
	GameEvents.Subscribe( "player_fullyjoined", OnUpdateHeroSelection );
	GameEvents.Subscribe( "player_team", OnUpdateHeroSelection );

})();

