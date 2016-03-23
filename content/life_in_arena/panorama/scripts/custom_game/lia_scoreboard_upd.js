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

function _ScoreboardUpdater_UpdatePlayerPanelMy( scoreboardConfig, playersContainer, playerId, localPlayerTeamId, score, place )
{
	//$.Msg( "                  _ScoreboardUpdater_UpdatePlayerPanelMy:score ", score );
	//$.Msg( "                  _ScoreboardUpdater_UpdatePlayerPanelMy:score.KillsCreeps ", score.KillsCreeps );
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	//
	var playerPanelName = "_dynamic_player_" + place;//playerId;
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
	//$.Msg( "                  _ScoreboardUpdater_UpdatePlayerPanelMy: ", playerPanel );
	//
	//var KillsCreeps = data.KillsCreeps
	var playerInfo = Game.GetPlayerInfo( playerId );
	var isTeammate = false;
	//$.Msg( "                  _ScoreboardUpdater_UpdatePlayerPanelMy: playerId ", playerId );
	//$.Msg( "                  _ScoreboardUpdater_UpdatePlayerPanelMy:  playerInfo ", playerInfo );
	if ( playerInfo )
	{
		isTeammate = ( playerInfo.player_team_id == localPlayerTeamId );
		playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );
		playerPanel.SetHasClass( "local_player_teammate", isTeammate && ( playerId != Game.GetLocalPlayerID() ) );
		playerPanel.SetHasClass("is_local_player", localPlayerId == playerId );
		playerPanel.SetHasClass( "player_muted", Game.IsPlayerMuted( playerId ) );
		//_ScoreboardUpdater_SetTextSafe( playerPanel, "RespawnTimer", ( playerInfo.player_respawn_seconds + 1 ) ); // value is rounded down so just add one for rounded-up
		_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerName", playerInfo.player_name );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Level", playerInfo.player_level );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "KillsCreeps", score.KillsCreeps );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "KillsBosses", score.KillsBosses );
		_ScoreboardUpdater_SetTextSafeToFixed( playerPanel, "Upd", score.PercUlu );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Deaths", score.Deaths );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Rating", score.Rating );
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
					if ( bufName.indexOf( "_2" ) >= 0 )
					{
						bufName = bufName.replace( "_2", "" );
					}
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


//=============================================================================
//=============================================================================
/*function ScoreboardUpdater_SetScoreboardActive( scoreboardHandle, isActive )
{
	if ( scoreboardHandle.scoreboardConfig === null )
	{
		return;
	}
	
	if ( isActive )
	{
		//_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardHandle.scoreboardConfig );
	}
}*/

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel( scoreboardHandle, teamId )
{
	if ( scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}
	
	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild( teamPanelName );
}

//=============================================================================
//=============================================================================
/*function ScoreboardUpdater_GetSortedTeamInfoList( scoreboardHandle )
{
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}

	if ( teamsList.length > 1 )
	{
		teamsList.sort( stableCompareFunc );		
	}
	
	return teamsList;
}*/
