"use strict";

var schedule = null;

function OpenButtonClick() {
	var TradeMain = $.FindChildInContext("#TradeMain")
	TradeMain.ToggleClass("Open");

	if (TradeMain.BHasClass("Open"))
		schedule = $.Schedule(0.1,RecalculateTradeResource);
	else
	{
		if (schedule != null)
		{
			$.CancelScheduled(schedule);
			schedule = null;
		}
		CleanResourceFields()
	}
}



function GetGoldSummary()
{
	var goldSum = 0;
	var playersContainer = $("#PlayersContainer");
	for (var i = 0; i < playersContainer.GetChildCount(); i++ )
	{
		var playerRowPanel = playersContainer.GetChild(i);
		goldSum += playerRowPanel.gold;
	}
 	return goldSum
}

function GetLumberSummary()
{
	var lumberSum = 0;
	var playersContainer = $("#PlayersContainer");
	for (var i = 0; i < playersContainer.GetChildCount(); i++ )
	{
		var playerRowPanel = playersContainer.GetChild(i);
		lumberSum += playerRowPanel.lumber;
	}
 	return lumberSum
}

function RecalculateTradeResource()
{
	var playersContainer = $("#PlayersContainer");
	//$.Msg("ololo");
	if ( GetGoldSummary() > Players.GetGold( Game.GetLocalPlayerID() ) )
	{
		for (var i = playersContainer.GetChildCount()-1; i >= 0; i-- )
		{
			var playerRowPanel = playersContainer.GetChild(i);
			playerRowPanel.gold -= GetGoldSummary() - Players.GetGold(Game.GetLocalPlayerID())

			if (playerRowPanel.gold < 0)
				playerRowPanel.gold = 0;

			playerRowPanel.FindChildTraverse("Gold").text = playerRowPanel.gold

			if ( GetGoldSummary() <= Players.GetGold( Game.GetLocalPlayerID() ) ) break;
		}

	}

	if ( GetLumberSummary() > Players.GetLumber( Game.GetLocalPlayerID() ) )
	{
		for (var i = playersContainer.GetChildCount()-1; i >= 0; i-- )
		{
			var playerRowPanel = playersContainer.GetChild(i);
			playerRowPanel.lumber -= GetLumberSummary() - Players.GetLumber(Game.GetLocalPlayerID())

			if (playerRowPanel.lumber < 0)
				playerRowPanel.lumber = 0;

			playerRowPanel.FindChildTraverse("Lumber").text = playerRowPanel.lumber

			if ( GetLumberSummary() <= Players.GetLumber( Game.GetLocalPlayerID() ) ) break;
		}

	}
	//$.Msg("RecalculateTradeResource")
	schedule = $.Schedule(0.1,RecalculateTradeResource);
}

function CleanResourceFields()
{
	var playersContainer = $("#PlayersContainer");
	for (var i = 0; i < playersContainer.GetChildCount(); i++ )
	{
		var playerRowPanel = playersContainer.GetChild(i);
		playerRowPanel.gold = 0;
		playerRowPanel.lumber = 0;

		playerRowPanel.FindChildTraverse("Gold").text = 0
		playerRowPanel.FindChildTraverse("Lumber").text = 0

	}
}

function TradeRequest()
{
	var playersContainer = $("#PlayersContainer");
	for (var i = 0; i < playersContainer.GetChildCount(); i++ )
	{
		var playerRowPanel = playersContainer.GetChild(i);
		if ( playerRowPanel.gold > 0 || playerRowPanel.lumber > 0 ) 
		{
			var eventData = eventData || {}
			eventData[playerRowPanel.playerID] = {}
			eventData[playerRowPanel.playerID]["gold"] = playerRowPanel.gold
			eventData[playerRowPanel.playerID]["lumber"] = playerRowPanel.lumber
		}
	}

	if (eventData) 
		GameEvents.SendCustomGameEventToServer("lia_trade_request", eventData);

	OpenButtonClick()
}


(function()
{
	var playersContainer = $("#PlayersContainer");
	var isOnePlayer = true

	for (var PlayerID of Game.GetAllPlayerIDs()) {
		if ( Game.GetLocalPlayerID() != PlayerID && !Players.IsSpectator(PlayerID) ) {	
			
			var PlayerPanel = $.CreatePanel("Panel", playersContainer, "player"+PlayerID)
			PlayerPanel.SetAttributeInt("player_id", PlayerID);
			PlayerPanel.BLoadLayout("file://{resources}/layout/custom_game/trade/player_row.xml", false, false )
			isOnePlayer = false
		}

		
	}

	if (isOnePlayer) {
		$.FindChildInContext("#OpenButton").visible = false;
		return;
	}

})();