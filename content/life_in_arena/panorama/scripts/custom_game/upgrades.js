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
	container.ToggleClass("opened")

	$("#OpenButton").ToggleClass("opened")

	var childrens = container.Children()

	for (var child in childrens)
	{
		if (container.BHasClass("opened"))
		{ 
			childrens[child].style.position = "0px " + ((525-78*child)-78) +"px 0px"
			//childrens[child].style.opacity = "1"
		}
		else
		{ 
			childrens[child].style.position = "0px 580px 0px"
			//childrens[child].style.opacity = "0"
		}
	}
}

function Upgrade(upgradeName)
{
	var upgradeButton = $.CreatePanel("Button", $("#UpgradesContainer"), upgradeName)
	upgradeButton.style.backgroundImage = "url('file://{images}/custom_game/upgrades/" + upgradeName + ".png')"
	upgradeButton.style.position = "0px 580px 0px"
	upgradeButton.AddClass("Upgrade")

	upgradeButton.upgradeName = upgradeName

	upgradeButton.SetPanelEvent("onmouseactivate", function() { 
		$.Msg("upgrade_request ",upgradeName)
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
	
	var playerID = Game.GetLocalPlayerID()
	
	$("#LumberAmount").text = Players.GetLumber(playerID)
	$("#LumberAmount").visible = Players.GetLumber(playerID) != 0

	var playerID = Game.GetLocalPlayerID()
	var data = CustomNetTables.GetTableValue("lia_player_table", "UpgradesPlayer"+playerID);
	var container = $("#UpgradesContainer")
	for (var upgradeName in data)
	{
		var upgradeButton = container.FindChild(upgradeName)

		upgradeButton.enabled = 
			( Players.GetUpgradeLumberCost(upgradeName,Players.GetUpgradeLevel(upgradeName,playerID)) <= Players.GetLumber(playerID) ) 
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
	return upgradesInfo[upgradeName]["BonusPerLevel"]*level
}

Players.GetUpgradeBonusPerLevel = function(upgradeName)
{
	return upgradesInfo[upgradeName]["BonusPerLevel"]
}
