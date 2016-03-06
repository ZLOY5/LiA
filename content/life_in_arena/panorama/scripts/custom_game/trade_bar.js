"use strict";


var statePanelTrade = false;


function ClickHide()
{
	if (statePanelTrade === true)
		statePanelTrade = false;
	else
		statePanelTrade = true;
	$.GetContextPanel().SetHasClass("could_vis", statePanelTrade);
	$.GetContextPanel().SetHasClass("closed", statePanelTrade);
}

function ColorChange()
{
	var dropDown = $.FindChildInContext("#HeroPick");
	var PlayerID = dropDown.GetSelected().GetAttributeInt("player_id", -1)
	var playerColor = GameUI.CustomUIConfig().players_color[PlayerID];
	var backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '60 ) );'
	dropDown.style.backgroundColor = backgroundColor;
}

function Increment(resource, bDecrement) {
	
	var Increment;

	if (GameUI.IsShiftDown()) {
		if (resource == 1)
			Increment = 100;
		else
			Increment = 10;
	}
	else {
		if (resource == 1)
			Increment = 10;
		else
			Increment = 1;
	}

	var TextEntry
	var resourceAmount

	if (resource == 1) { 
		TextEntry = $.FindChildInContext("#GoldEntry");
		resourceAmount = Players.GetGold(Game.GetLocalPlayerID());
	}
	else {
		TextEntry = $.FindChildInContext("#LumberEntry");
		resourceAmount = Players.GetLumber(Game.GetLocalPlayerID());
		//$.Msg(resourceAmount);
	}

	var currentSum = parseInt(TextEntry.text);

	if (isNaN(currentSum)) {
		currentSum = 0;
	}

	var newSum;
	
	if (bDecrement)
		newSum = currentSum - Increment;
	else
		newSum = currentSum + Increment;

	if (newSum < 0) 
		newSum = 0;

	if (newSum > resourceAmount)
		newSum = resourceAmount;
	

	TextEntry.text = newSum;
}

function RecalculateTradeResource() {
	var TextEntry = $.FindChildInContext("#GoldEntry");
	var resourceAmount = Players.GetGold(Game.GetLocalPlayerID());

	var currentSum = parseInt(TextEntry.text);

	if (TextEntry.text == '') 
		currentSum = 0;
	

	if ( currentSum > resourceAmount ) 
		currentSum = resourceAmount;
	

	if (TextEntry.text != String(currentSum)) 
		TextEntry.text = currentSum;

	//Lumber
	TextEntry = $.FindChildInContext("#LumberEntry");
	resourceAmount = Players.GetLumber(Game.GetLocalPlayerID());

	currentSum = parseInt(TextEntry.text);

	if ( isNaN(currentSum) )
		currentSum = 0;

	if ( currentSum > resourceAmount )
		currentSum = resourceAmount;

	if (TextEntry.text != String(currentSum))
		TextEntry.text = currentSum;

	$.Schedule(0.03,RecalculateTradeResource);
}


function TradeRequest() {
	var GoldEntry = $.FindChildInContext("#GoldEntry");
	var LumberEntry = $.FindChildInContext("#LumberEntry");
	var dropDown = $.FindChildInContext("#HeroPick");

	//RecalculateTradeResource(false)

	var gold = parseInt(GoldEntry.text);
	var lumber = parseInt(LumberEntry.text);
	var tradePlayerID = dropDown.GetSelected().GetAttributeInt("player_id", -1);

	if (!(gold == 0 && lumber == 0))
		GameEvents.SendCustomGameEventToServer("lia_trade_request", {gold:gold, lumber:lumber, tradePlayerID:tradePlayerID});

	OpenButtonClick()
	//$.Msg("TradeRequest")
}

function ResetResourceEntry() {
	$.FindChildInContext("#GoldEntry").text = "0";
	$.FindChildInContext("#LumberEntry").text = "0";
}


function OpenButtonClick() {
	$.FindChildInContext("#TradeMain").ToggleClass("Open");
	ResetResourceEntry()
}

(function()
{
	var dropDown = $.FindChildInContext("#HeroPick");
	var isFirstPlayer = true
	for (var PlayerID of Game.GetAllPlayerIDs()) {
		
		if (Players.IsValidPlayerID(PlayerID) && Game.GetLocalPlayerID() != PlayerID) {
			var PlayerPanel = $.CreatePanel("Label", dropDown, "player"+PlayerID);
			var playerColor = GameUI.CustomUIConfig().players_color[PlayerID];
			var heroName = $.Localize("#"+Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(PlayerID)));
			dropDown.AddOption(PlayerPanel);
			PlayerPanel.SetAttributeInt("player_id", PlayerID);
			PlayerPanel.text = Players.GetPlayerName(PlayerID)+' | '+ heroName;
			PlayerPanel.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '60 ) );';
			if (isFirstPlayer) {
				dropDown.SetSelected(PlayerPanel);
				dropDown.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '60 ) );';
				isFirstPlayer = false;
			}

		}
	}

	$.Schedule(0.03,RecalculateTradeResource)

})();