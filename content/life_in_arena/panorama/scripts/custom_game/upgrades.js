"use strict";

var upgradesInfo

var upgradeList = [	"upgrade_attack_damage",
					"upgrade_attack_speed",
					"upgrade_armor",
					"upgrade_health",
					"upgrade_health_regen",
					"upgrade_mana",
					"upgrade_mana_regen",
					
				];

function Open()
{
	var container = $("#UpgradesContainer")
	
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
	if ( dotaHud.FindChildTraverse("shop").BHasClass("ShopOpen") ) {
		$.DispatchEvent( "DOTAShopHideShop" );
		container.AddClass("opened")
	}
	else
		container.ToggleClass("opened")
	
}

function Upgrade(upgradeName)
{
	var upgradeButton = $.CreatePanel("Button", $("#UpgradesContainer"), upgradeName)
	upgradeButton.style.backgroundImage = "url('file://{images}/custom_game/upgrades/" + upgradeName + ".png')"
	upgradeButton.style.position = "0px 580px 0px"
	upgradeButton.AddClass("Upgrade")

	upgradeButton.upgradeName = upgradeName

	upgradeButton.SetPanelEvent("onmouseactivate", function() { 
		//$.Msg("upgrade_request ",upgradeName,"   "+Game.Time())
		GameEvents.SendCustomGameEventToServer("upgrade_request", {upgradeName: upgradeName}) 
	})

	upgradeButton.SetPanelEvent("onmouseover", function() { 
		$.DispatchEvent("UIShowCustomLayoutParametersTooltip", upgradeButton, "UpgradeTooltip", 
			"file://{resources}/layout/custom_game/upgrade_tooltip.xml", "upgradeName="+upgradeName);
		upgradeButton.AddClass("tooltip")
	})

	upgradeButton.SetPanelEvent("onmouseout", function() { 
		$.DispatchEvent("UIHideCustomLayoutTooltip", upgradeButton, "UpgradeTooltip");
		upgradeButton.RemoveClass("tooltip")
	})
}

function Update()
{
	$.Schedule(0.03,Update)


	var container = $("#UpgradesContainer")

	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
	container.SetHasClass("ShopOpen", dotaHud.FindChildTraverse("shop").BHasClass("ShopOpen") )
	
	var playerID = Game.GetLocalPlayerID()
	
	//if ( $("#LumberAmount").text != Players.GetLumber(playerID))
	//	$.Msg(Players.GetLumber(playerID),"   "+Game.Time())


	$("#LumberAmount").text = Players.GetLumber(playerID)
	//$("#LumberAmount").visible = Players.GetLumber(playerID) != 0

	var playerID = Game.GetLocalPlayerID()
	var data = CustomNetTables.GetTableValue("lia_player_table", "UpgradesPlayer"+playerID);
	var container = $("#UpgradesContainer")
	for (var upgradeName in data)
	{
		var upgradeButton = container.FindChild(upgradeName)

		upgradeButton.enabled = 
			( Players.GetUpgradeLumberCost(upgradeName,Players.GetUpgradeLevel(upgradeName,playerID)) 
				<= Players.GetLumber(playerID) ) 
			&&  ( Players.GetMaxUpgradeLevel(upgradeName) > Players.GetUpgradeLevel(upgradeName,playerID) )

		if ( upgradeButton.BHasClass("tooltip") )
			$.DispatchEvent("UIShowCustomLayoutParametersTooltip", upgradeButton, "UpgradeTooltip", 
			"file://{resources}/layout/custom_game/upgrade_tooltip.xml", "upgradeName="+upgradeName);
	}
}

(function () { 
	upgradesInfo = CustomNetTables.GetTableValue("upgrades", "info")

	for (var i = 0; i != upgradeList.length ; i++) {
		//$.Msg(upgradeList[i])
		Upgrade(upgradeList[i])
	} 
	
	$.Schedule(0.03,Update)
})();





Players.GetUpgradeLumberCost = function(upgradeName,level)
{
	return upgradesInfo[upgradeName]["InitialLumberCost"] + upgradesInfo[upgradeName]["LumberCostPerLevel"]*level
}

Players.GetMaxUpgradeLevel = function(upgradeName)
{
	return upgradesInfo[upgradeName]["MaxLevel"]
}

Players.GetUpgradeLevel = function(upgradeName,playerID)
{
	var netTable = CustomNetTables.GetTableValue("lia_player_table", "UpgradesPlayer"+playerID);
	if (typeof(netTable) == "object") {
		return netTable[upgradeName] 
	}
	return 0 
}

Players.GetCurrentUpgradeBonus = function(upgradeName,playerID)
{
	var level = Players.GetUpgradeLevel(upgradeName,playerID)
	if (level > 0)
		return  Players.GetUpgradeBonus(upgradeName,level);

	return 0
}

Players.GetUpgradeBonus = function(upgradeName,level)
{
	return Math.floor(upgradesInfo[upgradeName]["BonusPerLevel"]*level*100)/100
}

Players.GetUpgradeBonusPerLevel = function(upgradeName)
{
	return Math.floor(upgradesInfo[upgradeName]["BonusPerLevel"]*100)/100
}
