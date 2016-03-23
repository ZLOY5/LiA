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

function GetScore_FromPlayerId(data, playerId)
{
	
	for ( var i = 1; i <= 8; ++i )
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
					"PercUlu" : data.PercUlu[i],
					
					
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

	var containerPanel = $( "#TeamsContainer")
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
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

		var plAndParList = OnUpdAction_GetSortedPlayersList(teamPlayers, data);
		//_ScoreboardUpdater_UpdatePlayerPanelMy( g_ScoreboardHandle.scoreboardConfig, playersContainer, 3, localPlayerTeamId, score );
		for ( var i = 0; i < plAndParList.length; ++i )

		{
			//_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )

			var score = GetScore_FromPlayerId(data,plAndParList[i].playerId); //.playerId  plList[i]

			_ScoreboardUpdater_UpdatePlayerPanelMy( g_ScoreboardHandle.scoreboardConfig, playersContainer, plAndParList[i].playerId, localPlayerTeamId, score, i ); //.playerId   plList[i]
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
	GameEvents.Subscribe( "upd_action",  OnUpdAction);
	GameEvents.Subscribe( "upd_action_hide",  OnUpdActionHide);
	
	
})();