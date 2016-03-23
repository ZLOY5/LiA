"use strict";

var _endScoreboardHandle;
var _containerPanel;


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
					"PercUlu" : data.PercUlu[i],
					//"SID"	: data.SteamId[i],
					
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
	var allscore = 0;
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
	var numS =0;
	var teamPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
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
		//$.Msg( "                  plAndParList =", plAndParList );
		//_ScoreboardUpdater_UpdatePlayerPanelMy( _endScoreboardHandle.scoreboardConfig, playersContainer, 3, localPlayerTeamId, score );
		var score
		for ( var i = 0; i < plAndParList.length; ++i )
		//for ( var i = 0; i < plList.length; ++i )
		//for ( var playerId of teamPlayers )
		{
			//_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
			
			score = GetScore_FromPlayerId(data,plAndParList[i].playerId); //.playerId  plList[i]
			if (i<4)
			{
				allscore = allscore + score.Rating*(0.6+0.1*i);
				//numS = numS+1;
			}
				
			//$.Msg( "                  OnUpdActionEnd: 	score ", score );
			_ScoreboardUpdater_UpdatePlayerPanelMy( _endScoreboardHandle.scoreboardConfig, playersContainer, plAndParList[i].playerId, localPlayerTeamId, score, i ); //.playerId   plList[i]
			
			/*var playersC = playersContainer.FindChildInLayoutFile( "PlayerAndHeroName" );
			$.Msg( "                  playersC ", playersC);
			playersC.html = true;
			playersC.href = "http://steamcommunity.com/profiles/" + score.SID +"/"; 
			$.Msg( "                  PROFILE ", "http://steamcommunity.com/profiles/" + score.SID +"/");*/
			//PlayerResource:GetSteamAccountID(pID)
		}
		//allscore = allscore/numS;
		
	}
	
	//
	allscore = allscore - data.barrelExplosions*75;
	//
	
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
	var sec = Math.floor(Game.GetGameTime());
	var extraForTime = 0;
	//
	var winningTeamId = Game.GetGameWinner();
	//$.Msg( "                  winningTeamId ", winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if (winningTeamId === 3)
	{
		endScreenVictory.text = $.Localize( "#end_screen_lose" ) ;	
	}
	else
	{
		endScreenVictory.text = $.Localize( "#end_screen_victory" ) ;	
		if (3000-sec > 0)
			extraForTime  = (3000 - sec) * 1;
		if (extraForTime > 1500)
			extraForTime = 1500;


	}
	//
	allscore = allscore + extraForTime;
	//
	//var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.5;
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
	
	/*var winningTeamId = Game.GetGameWinner();
	var winningTeamDetails = Game.GetTeamDetails( winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if ( endScreenVictory )
	{
		endScreenVictory.SetDialogVariable( "winning_team_name", $.Localize( winningTeamDetails.team_name ) );

		//if ( GameUI.CustomUIConfig().team_colors )
		{
			/*var teamColor = GameUI.CustomUIConfig().team_colors[ winningTeamId ];
			teamColor = teamColor.replace( ";", "" );
			endScreenVictory.style.color = teamColor + ";";
		}
	}*/
	//
	//#LiaAllScore
	var endScreenAllScore = $( "#StatusScore" );
	//endScreenVictory.SetDialogVariable( "winning_team_score", $.Localize( "#LiaAllScore" + allscore ) );
	endScreenAllScore.text = $.Localize( "#LiaAllScore" ) + allscore.toFixed(0) ; 
	//
	var endScreenTime = $( "#StatusTime" );
	//
	var min = Math.floor(sec/60);	sec = sec - min*60;
	var hour = Math.floor(min/60);  min = min - hour*60;
	var strokaSec = "";
	var strokaMin = "";
	var strokaHour = "";
	if (hour<10)
		strokaHour = "0" + hour
	else
		strokaHour = hour;
	if (min<10)
		strokaMin = "0" + min
	else
		strokaMin = min;
	if (sec<10)
		strokaSec = "0" + sec
	else
		strokaSec = sec;
	//
	if (hour !== 0)
		endScreenTime.text = $.Localize( "#LiaTime" ) + strokaHour + ":" + strokaMin + ":" + strokaSec
	else
		endScreenTime.text = $.Localize( "#LiaTime" ) + strokaMin + ":" + strokaSec;
	
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
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_end_screen_player.xml",
	};
	_containerPanel = $( "#TeamsContainer" );
	_endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, _containerPanel );

	
	GameEvents.Subscribe( "upd_action_end",  OnUpdActionEnd);
	GameUI.SetCameraDistance(0)
	GameUI.SetCameraPitchMin(10)
	GameUI.SetCameraPitchMax(10)
	GameUI.SetCameraLookAtPositionHeightOffset(500)
	GameUI.SetCameraYaw(45)
})();
