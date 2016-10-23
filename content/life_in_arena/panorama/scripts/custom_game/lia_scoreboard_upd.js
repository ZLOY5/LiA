"use strict";


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;
	
	childPanel.text = textValue;
}

function _ScoreboardUpdater_SetTextSafeToFixed( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;
	
	childPanel.text = textValue.toFixed(1);
}

function _ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId)
{

	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	

	var customPlayerInfo = CustomNetTables.GetTableValue("lia_player_table", "Player"+playerId)

	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( scoreboardConfig.playerXmlName, false, false );
	}
	playerPanel.SetAttributeInt( "player_id", playerId );
	//
	playerPanel.text = "asdeqwe";

	var playerInfo = Game.GetPlayerInfo( playerId );
	var isTeammate = false;

	if ( playerInfo && customPlayerInfo)
	{

		isTeammate = ( playerInfo.player_team_id == localPlayerTeamId );
		if ( isTeammate )
		{
			var ultStateOrTime = Game.GetPlayerUltimateStateOrTime( playerId );
		}
		playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );
		playerPanel.SetHasClass( "local_player_teammate", isTeammate && ( playerId != Game.GetLocalPlayerID() ) );
		playerPanel.SetHasClass("is_local_player", localPlayerId == playerId );
		playerPanel.SetHasClass( "player_muted", Game.IsPlayerMuted( playerId ) );

		if (localPlayerId != playerId)
			playerPanel.SetHasClass( "ready_to_round", customPlayerInfo.readyToRound );
		
		_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerName", playerInfo.player_name );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Level", playerInfo.player_level );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "KillsCreeps", customPlayerInfo.killedCreeps );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "KillsBosses", customPlayerInfo.killedBosses );
		_ScoreboardUpdater_SetTextSafeToFixed( playerPanel, "Upd", customPlayerInfo.lumberSpent/333*100 );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Deaths", customPlayerInfo.heroDeaths );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Rating", customPlayerInfo.rating );
		
		var playerPortrait = playerPanel.FindChildInLayoutFile( "HeroIcon" );
		if ( playerPortrait )
		{
			if ( playerInfo.player_selected_hero !== "" )
			{
				playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
			}
			else
			{
				playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
			}
		}

		var playerColorBar = playerPanel.FindChildInLayoutFile( "PlayerColorBar" );
		if (playerColorBar)
		{
			var playerColor = GameUI.CustomUIConfig().players_color[playerId];
			playerColorBar.style.backgroundColor = 'gradient( linear, -15% 0%, 115% 0%, from( #00000000 ), color-stop( 0.3, ' + playerColor + '), color-stop( 0.7, ' + playerColor + '), to( #00000000 ) );'
		}


		//
		var heroNameAndDescription = playerPanel.FindChildInLayoutFile( "HeroNameAndDescription" );
		if ( heroNameAndDescription )
		{
			if ( playerInfo.player_selected_hero_id == -1 )
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) );
			}
			else
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#"+playerInfo.player_selected_hero ) );
			}
			heroNameAndDescription.SetDialogVariableInt( "hero_level",  playerInfo.player_level );
		}		

		playerPanel.SetHasClass( "player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
		playerPanel.SetHasClass( "player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
		playerPanel.SetHasClass( "player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );
			
		var panel = playersContainer.GetChild(customPlayerInfo.place-1)
		if (panel !== null) 
			playersContainer.MoveChildBefore(playerPanel,playersContainer.GetChild(customPlayerInfo.place-1))
			playerPanel.style.zIndex = -customPlayerInfo.place

		playerPanel.SetHasClass( "player_ultimate_ready", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY ) );
		playerPanel.SetHasClass( "player_ultimate_no_mana", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA) );
		playerPanel.SetHasClass( "player_ultimate_not_leveled", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED) );
		playerPanel.SetHasClass( "player_ultimate_hidden", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN) );
		playerPanel.SetHasClass( "player_ultimate_cooldown", ( ultStateOrTime > 0 ) );

	}
	var playerItemsContainer = playerPanel.FindChildInLayoutFile( "PlayerItemsContainer" );
	if ( playerItemsContainer )
	{

		for ( var i = 0; i < 6; ++i )
		{
			var itemPanel = playerItemsContainer.FindChildInLayoutFile( "_dynamic_item_" + i );
			itemPanel.SetAttributeInt( "playerId", playerId );

			var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
			var itemEntId = Entities.GetItemInSlot(heroEntId,i);
			if (itemEntId != -1) {
				var TextureName = Abilities.GetAbilityTextureName( itemEntId )
				//$.Msg( "		TextureName = ", TextureName );
				var bufName = TextureName;

				if ( bufName.indexOf( "recipe" ) >= 0 || bufName.indexOf( "item_datadriven" ) >= 0 )
				{
					item_image_name = "file://{images}/items/recipe.png";
				}
				else
				{
					/*if ( bufName.indexOf( "_2" ) >= 0 )
					{
						bufName = bufName.replace( "_2", "" );
					}*/
					var item_image_name = "file://{images}/items/" + bufName.replace( "item_", "" ) + ".png";

					//$.Msg( "		item_image_name = ", item_image_name );
				}
				
				itemPanel.SetImage( item_image_name );
				itemPanel.itemName = Abilities.GetAbilityName(itemEntId);

			}	
			else
			{
				itemPanel.SetImage( "" );
			}
		}

	}

	


}




//=============================================================================
//=============================================================================



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


function ScoreboardUpdater_GetTeamPanel( scoreboardHandle, teamId )
{
	if ( scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}
	
	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild( teamPanelName );
}

