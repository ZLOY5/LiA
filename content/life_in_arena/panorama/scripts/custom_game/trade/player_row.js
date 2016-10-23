"use strict";
var context;

function CheckHeroName() {
	var withoutHero = false
	
	var heroName = $.Localize("#"+Players.GetPlayerSelectedHero(context.playerID));
	if (heroName != "") {
		$.FindChildInContext("#PlayerName").text = $.FindChildInContext("#PlayerName").text+' | '+ heroName;
		$.FindChildInContext("#HeroImage").heroname = Players.GetPlayerSelectedHero(context.playerID)
	}
	else 
		withoutHero = true;
		
	if (withoutHero) 
		$.Schedule(0.5,CheckHeroName);

	$.Msg("CheckHeroNames");
}

function ChangeGold(bIncrement)
{
	var addGold = 10;
	if (GameUI.IsShiftDown())
		addGold = 100;

	if (bIncrement)
		context.gold += addGold;
	else
		context.gold -= addGold;
	
	var GoldTradeSum = GetGoldSummary()

	if ( GetGoldSummary() > Players.GetGold(Game.GetLocalPlayerID()) )
	{
		context.gold -= GetGoldSummary() - Players.GetGold(Game.GetLocalPlayerID())
	}

	if (context.gold < 0)
		context.gold = 0;

	$.FindChildInContext("#Gold").text = context.gold;
}

function ChangeLumber(bIncrement)
{
	var addLumber = 1;
	if (GameUI.IsShiftDown())
		addLumber = 10;

	if (bIncrement)
		context.lumber += addLumber;
	else
		context.lumber -= addLumber;
	
	var LumberTradeSum = GetLumberSummary()

	if ( GetLumberSummary() > Players.GetLumber(Game.GetLocalPlayerID()) )
	{
		context.lumber -= GetLumberSummary() - Players.GetLumber(Game.GetLocalPlayerID())
	}

	if (context.lumber < 0)
		context.lumber = 0;

	$.FindChildInContext("#Lumber").text = context.lumber;
}

function GetGoldSummary()
{
	var goldSum = 0;
	var playersContainer = context.GetParent();
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
	var playersContainer = context.GetParent();
	for (var i = 0; i < playersContainer.GetChildCount(); i++ )
	{
		var playerRowPanel = playersContainer.GetChild(i);
		lumberSum += playerRowPanel.lumber;
	}
 	return lumberSum
}

function SharedHeroToggle()
{
	GameEvents.SendCustomGameEventToServer("shared_hero_toggle", { togglePlayerID: context.playerID, state: Boolean($.FindChildInContext("#Hero").checked) });
}

function SharedUnitsToggle()
{
	GameEvents.SendCustomGameEventToServer("shared_units_toggle", { togglePlayerID: context.playerID, state: Boolean($.FindChildInContext("#Units").checked) });
}

function DisableHelpToggle()
{
	GameEvents.SendCustomGameEventToServer("disable_help_toggle", { togglePlayerID: context.playerID, state: Boolean($.FindChildInContext("#DisableHelp").checked) });
}

(function()
{
	context = $.GetContextPanel()

	context.gold = 0
	context.lumber = 0
	context.playerID = context.GetAttributeInt("player_id", -1)


	var playerColor = GameUI.CustomUIConfig().players_color[context.playerID];
	var heroName = $.Localize("#"+Players.GetPlayerSelectedHero(context.playerID));

	var playerNameLabel = $.FindChildInContext("#PlayerName")

	playerNameLabel.text = Players.GetPlayerName(context.playerID)

	var needHeroName = false;
	if (heroName != "")
		playerNameLabel.text = playerNameLabel.text+' | '+ heroName;
	else {
		needHeroName = true;
	}

	$.FindChildInContext("#PlayerRowContainer").style.backgroundColor = 'gradient( linear, 0% 0%, 110% 0%, from( #00000000 ), color-stop( 0.2, ' + playerColor + '44 ), to( #00000000 ) );'

	$.FindChildInContext("#HeroImage").heroname = Players.GetPlayerSelectedHero(context.playerID)
	//$.Msg($.FindChildInContext("#HeroImage"))

	if (needHeroName)
		$.Schedule(0.5, CheckHeroName)

})();