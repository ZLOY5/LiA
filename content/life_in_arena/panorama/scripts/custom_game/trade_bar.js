"use strict";



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
	if ($.FindChildInContext("#TradeMain").BHasClass("Open")) {
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
	}
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


/*dota_chat_event
userid ( short )
gold ( short )
message ( short )*/

function ResetResourceEntry() {
	$.FindChildInContext("#GoldEntry").text = "0";
	$.FindChildInContext("#LumberEntry").text = "0";
}


function OpenButtonClick() {
	var TradeMain = $.FindChildInContext("#TradeMain")
	TradeMain.ToggleClass("Open");
	ResetResourceEntry();
	

	if (~TradeMain.BHasClass("Open"))
		$.GetContextPanel().GetParent().SetFocus()

}

function CheckHeroNames() {
	var withoutHero = false
	var dropDown = $.FindChildInContext("#HeroPick");
	var playerLabels = dropDown.GetAllOptions()
	for (var label of playerLabels) {
		if (label.GetAttributeInt("needHeroName", -1) == 1) {
			var PlayerID = label.GetAttributeInt("player_id", -1)
			var heroName = $.Localize("#"+Players.GetPlayerSelectedHero(PlayerID));
			if (hero != "") {
				label.text = PlayerPanel.text+' | '+ heroName;
				label.SetAttributeInt("needHeroName", -1)
			}
			else 
				withoutHero = true;
		}
	}

	if (withoutHero) 
		$.Schedule(0.5,CheckHeroNames);

	$.Msg("CheckHeroNames");
}

(function()
{
	var dropDown = $.FindChildInContext("#HeroPick");
	var isFirstPlayer = true
	var withoutHero = false

	for (var PlayerID of Game.GetAllPlayerIDs()) {
		
		if ( Game.GetLocalPlayerID() != PlayerID && !Players.IsSpectator(PlayerID) ) {
			var PlayerPanel = $.CreatePanel("Label", dropDown, "player"+PlayerID);
			var playerColor = GameUI.CustomUIConfig().players_color[PlayerID];
			var heroName = $.Localize("#"+Players.GetPlayerSelectedHero(PlayerID));
			
			dropDown.AddOption(PlayerPanel);
			
			PlayerPanel.SetAttributeInt("player_id", PlayerID);
			PlayerPanel.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '60 ) );';
			PlayerPanel.text = Players.GetPlayerName(PlayerID);
			if (heroName != "")
				PlayerPanel.text = PlayerPanel.text+' | '+ heroName;
			else {
				PlayerPanel.SetAttributeInt("needHeroName", 1);
				withoutHero = true;
			}

			if (isFirstPlayer) {
				dropDown.SetSelected(PlayerPanel);
				dropDown.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '60 ) );';
				isFirstPlayer = false;
			}
		}
	}

	if (isFirstPlayer) {
		$.FindChildInContext("#OpenButton").visible = false;
		return;
	}

	if (withoutHero) 
		$.Schedule(0.5,CheckHeroNames);

	$.Schedule(0.03,RecalculateTradeResource);
})();