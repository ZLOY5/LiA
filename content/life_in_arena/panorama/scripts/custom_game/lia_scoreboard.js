"use strict";

var g_ScoreboardHandle = null;
var visible;

/*function AutoUpdateScoreboard()
{
	if (!visible)
		return;

	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, false );
    $.Schedule( 1, AutoUpdateScoreboard );
}*/

/*function UpdatePlayers()
{
	g_ScoreboardHandle.scoreboardConfig["updatePlayersCount"] = false;
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, visible );
}*/

function SetFlyoutScoreboardVisible( bVisible )
{
	visible = bVisible;
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", visible );
	/*if ( visible )
	{
		//AutoUpdateScoreboard( bVisible );
	}
	else
	{
		ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, false );
	}*/
}

function GetScore_FromPlayerId(data, playerId)
{
	//var data = params.data;
	//var PlayersId = data.PlayersId;
	//$.Msg( "                  GetScore_FromPlayerId:data ", data );
	
	/*if (playerId == 3)
	{
		var score =
		{
			"KillsCreeps" : 0,
			"KillsBosses" : 0,
			"Deaths" : 0,
			"Rating" : 100,
			
		};
		return score;
	}*/
	
	for ( var i = 1; i <= 8; ++i )
	//for ( var plId of PlayersId )
	{
		if (data.PlayersId[i] !== null)
		{
			
			if (data.PlayersId[i] === playerId)
			{
				var score =
				{
					"KillsCreeps" : data.KillsCreeps[i],
					"KillsBosses" : data.KillsBosses[i],
					"Deaths" : data.Deaths[i],
					"Rating" : data.Rating[i],
					
				};
				return score;
			}
		}

	}
}


function OnUpdAction_compareFunc( a, b ) 
{
	if ( a.scoreRating < b.scoreRating )
	{
		return 1; // [ B, A ]
	}
	else if ( a.scoreRating > b.scoreRating )
	{
		return -1; // [ A, B ]
	}
	else
	{
		return 0;
	}
};

function OnUpdAction_GetSortedPlayersList(teamPlayers, data )
{
	var playersAndParamsList = [];

	for ( var playerId of teamPlayers )
	{
		var score = GetScore_FromPlayerId(data,playerId)
		var dataIn = 
		{
			"scoreRating" : score.Rating,
			"playerId" : playerId,
		};
		playersAndParamsList.push( dataIn );
	}
	//playersAndParamsList.push( {"scoreRating" : 100, "playerId" : 3,} );

	if ( playersAndParamsList.length > 1 )
	{
		playersAndParamsList.sort( OnUpdAction_compareFunc );		
	}
	
	return playersAndParamsList;
}


function OnUpdActionHide( dataHide )
{
	SetFlyoutScoreboardVisible( dataHide.visible );
	//$.Msg( "                  				OnUpdActionHide    " );
}


// for current player
function OnUpdAction( data )
{
	// data.KillsCreeps[i], i = number tHeroes
	//$.Msg( "                  OnUpdAction:data ", data.KillsCreeps[1] );
	//$.Msg( "                  OnUpdAction:data.da ", data.da );
	//
	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}
	//
	//var teamPanel = $.GetContextPanel();
	var containerPanel = $( "#TeamsContainer")
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( g_ScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}
	//$.Msg( "                  OnUpdAction:teamPanel ", teamPanel );
	//var playerId = data.playerId
	//var PlayerTeamId = data.PlayerTeamId
	/*var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_player.xml",
	};*/
	
	var teamPlayers = Game.GetPlayerIDsOnTeam( localPlayerTeamId );
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	//$.Msg( "                  OnUpdAction:playersContainer ", playersContainer );
	if ( playersContainer )
	{
		/*var plList = [];
		for ( var id of teamPlayers )
		{
			plList.push( id );
		}*/
		var plAndParList = OnUpdAction_GetSortedPlayersList(teamPlayers, data);
		//_ScoreboardUpdater_UpdatePlayerPanelMy( g_ScoreboardHandle.scoreboardConfig, playersContainer, 3, localPlayerTeamId, score );
		for ( var i = 0; i < plAndParList.length; ++i )
		//for ( var i = 0; i < plList.length; ++i )
		//for ( var playerId of teamPlayers )
		{
			//_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )

			var score = GetScore_FromPlayerId(data,plAndParList[i].playerId); //.playerId  plList[i]
			//$.Msg( "                  OnUpdAction:score ", score );
			_ScoreboardUpdater_UpdatePlayerPanelMy( g_ScoreboardHandle.scoreboardConfig, playersContainer, plAndParList[i].playerId, localPlayerTeamId, score, i ); //.playerId   plList[i]
		}
		
	}
	/*var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	if ( playersContainer )
	{
		_ScoreboardUpdater_UpdatePlayerPanelMy( g_ScoreboardHandle.scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
	}*/
	//_ScoreboardUpdater_UpdateAllPlayers( g_ScoreboardHandle.scoreboardConfig, teamPanel );
}

(function()
{
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" )); // 
	
	SetFlyoutScoreboardVisible( true );

	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
	GameEvents.Subscribe( "upd_action",  OnUpdAction);
	GameEvents.Subscribe( "upd_action_hide",  OnUpdActionHide);
	
	
})();