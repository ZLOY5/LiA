"use strict";
var plAndParList;

/*function GetPlace(GetContextPanelID)
{
	if (GetContextPanelID === "_dynamic_player_0")
		return 0;
	if (GetContextPanelID === "_dynamic_player_1")
		return 1;
	if (GetContextPanelID === "_dynamic_player_2")
		return 2;
	if (GetContextPanelID === "_dynamic_player_3")
		return 3;
	if (GetContextPanelID === "_dynamic_player_4")
		return 4;
	if (GetContextPanelID === "_dynamic_player_5")
		return 5;
	if (GetContextPanelID === "_dynamic_player_6")
		return 6;
	if (GetContextPanelID === "_dynamic_player_7")
		return 7;
}*/

//ItemShowTooltip0
function ItemShowTooltip0()
{
	var c = 0;
	//$.Msg( "                  plAndParList =", plAndParList );
	//$.Msg( "                  _dynamic_player_0 =", $( "#_dynamic_player_0" ) );
	//$.Msg( "                  $.GetContextPanel() =", $.GetContextPanel() );
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	//$.Msg( "                  panel.id =", panel.id );
	var playerId = panel.GetAttributeInt( "playerId", -1);
	//$.Msg( "                  playerId =", playerId );
	var PID = playerId; //GetPlace($.GetContextPanel().id)
	
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip0()
{
	var c = 0;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip1()
{
	var c = 1;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var PID = playerId;
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip1()
{
	var c = 1;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip2()
{
	var c = 2;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var PID = playerId;
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip2()
{
	var c = 2;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip3()
{
	var c = 3;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var PID = playerId;
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		//$.Msg( "                  itemEntId =", itemEntId );
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip3()
{
	var c = 3;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip4()
{
	var c = 4;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var PID = playerId;
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip4()
{
	var c = 4;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip5()
{
	var c = 5;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var PID = playerId;
	var playerItems = Game.GetPlayerItems( PID );
	if ( playerItems )
	{
		var heroEntId = Players.GetPlayerHeroEntityIndex(PID);
		var itemEntId = Entities.GetItemInSlot(heroEntId,c);
		if (itemEntId !== -1)
		{
			var itemName = Abilities.GetAbilityName( itemEntId );
			$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, itemName, heroEntId );
		}
	}
}

function ItemHideTooltip5()
{
	var c = 5;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}



/*function GetScore_FromPlayerId(data, playerId)
{
	
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
					"SID"	: data.SteamId[i],
					
				};
				return score;
			}
		}

	}
}*/

/*function OnUpdAction_compareFunc( a, b ) 
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
};*/

/*function OnUpdAction_GetSortedPlayersList(teamPlayers, data )
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
}*/

/*function OnUpdActionEnd( data )
{
	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}
	var teamPlayers = Game.GetPlayerIDsOnTeam( localPlayerTeamId );
	plAndParList = OnUpdAction_GetSortedPlayersList(teamPlayers, data);
}*/

(function()
{
	//GameEvents.Subscribe( "upd_action_end",  OnUpdActionEnd);
})();

