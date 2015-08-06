"use strict";

var _endScoreboardHandle
var _containerPanel


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

function OnUpdActionEnd( data )
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
	//$.Msg( "                  OnUpdActionEnd: _endScoreboardHandle ", _endScoreboardHandle );
	//var teamPanel = ScoreboardUpdater_GetTeamPanel( _endScoreboardHandle, localPlayerTeamId );
	//var teamPanel = $.GetContextPanel();
	var containerPanel = _containerPanel
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		//$.Msg( "                  OnUpdActionEnd:  teamPanel === null ");
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( _endScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}
	//$.Msg( "                  OnUpdActionEnd:  teamPanel ", teamPanel );
	//var playerId = data.playerId
	//var PlayerTeamId = data.PlayerTeamId
	/*var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_player.xml",
	};*/
	
	var teamPlayers = Game.GetPlayerIDsOnTeam( localPlayerTeamId );
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	//$.Msg( "                  OnUpdActionEnd:	playersContainer ", playersContainer );
	if ( playersContainer )
	{
		/*var plList = [];
		for ( var id of teamPlayers )
		{
			plList.push( id );
		}*/
		var plAndParList = OnUpdAction_GetSortedPlayersList(teamPlayers, data);
		//_ScoreboardUpdater_UpdatePlayerPanelMy( _endScoreboardHandle.scoreboardConfig, playersContainer, 3, localPlayerTeamId, score );
		for ( var i = 0; i < plAndParList.length; ++i )
		//for ( var i = 0; i < plList.length; ++i )
		//for ( var playerId of teamPlayers )
		{
			//_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )

			var score = GetScore_FromPlayerId(data,plAndParList[i].playerId); //.playerId  plList[i]
			//$.Msg( "                  OnUpdActionEnd: 	score ", score );
			_ScoreboardUpdater_UpdatePlayerPanelMy( _endScoreboardHandle.scoreboardConfig, playersContainer, plAndParList[i].playerId, localPlayerTeamId, score, i ); //.playerId   plList[i]
		}
		
	}
	
	/*var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}*/
	
	/*var containerPanel = $( "#TeamsContainer")
	var teamPanelName = "_dynamic_team_" + localPlayerTeamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( scoreboardConfig.teamXmlName, false, false);
	}
	$.Msg( "                  OnUpdAction:teamPanel ", teamPanel );
	*/
	
	
	//var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.2;
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
	
	var winningTeamId = Game.GetGameWinner();
	var winningTeamDetails = Game.GetTeamDetails( winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if ( endScreenVictory )
	{
		endScreenVictory.SetDialogVariable( "winning_team_name", $.Localize( winningTeamDetails.team_name ) );

		//if ( GameUI.CustomUIConfig().team_colors )
		{
			/*var teamColor = GameUI.CustomUIConfig().team_colors[ winningTeamId ];
			teamColor = teamColor.replace( ";", "" );
			endScreenVictory.style.color = teamColor + ";";*/
		}
	}

	/*var winningTeamLogo = $( "#WinningTeamLogo" );
	if ( winningTeamLogo )
	{
		var logo_xml = GameUI.CustomUIConfig().team_logo_large_xml;
		if ( logo_xml )
		{
			winningTeamLogo.SetAttributeInt( "team_id", winningTeamId );
			winningTeamLogo.BLoadLayout( logo_xml, false, false );
		}
	}*/
	

}

(function()
{
	//if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }
	//$.Msg( "                  function():  lia_end_screen ");
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_player.xml",
	};
	_containerPanel = $( "#TeamsContainer" )

	/*var teamPanelName = "_dynamic_team_2"; // _dynamic_team_2   why is exists?
	var teamPanel = _containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		$.Msg( "                  function():  teamPanel === null ");
		teamPanel = $.CreatePanel( "Panel",  _containerPanel, teamPanelName );
		teamPanel.BLoadLayout( scoreboardConfig.teamXmlName, false, false);
	}
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	
	var playerPanelName = "_dynamic_player_3";//playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );

	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		//playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( scoreboardConfig.playerXmlName, false, false );
	}
	playerPanel.SetAttributeInt( "player_id", 3 );
	//
	playerPanel.text = "asdeqwe";*/
	
	_endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, _containerPanel );
	//$.GetContextPanel().SetHasClass( "endgame", 1 );
	
	GameEvents.Subscribe( "upd_action_end",  OnUpdActionEnd);
})();
