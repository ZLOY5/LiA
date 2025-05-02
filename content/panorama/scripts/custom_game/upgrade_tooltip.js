function setupTooltip(data)
{		
    var upgradeName = $.GetContextPanel().GetAttributeString("upgradeName", "not found")

    var playerID = Game.GetLocalPlayerID()
    var level = Players.GetUpgradeLevel(upgradeName,playerID)

    $("#Title").text = $.Localize("#"+upgradeName)

    $("#Level").SetDialogVariable("level",level)

    $("#Description").text = "#"+upgradeName+"_description"
    $("#Description").SetDialogVariable("perLevelBonus",Players.GetUpgradeBonusPerLevel(upgradeName))

    $("#Bonus").text = "#"+upgradeName+"_bonus"
    $("#Bonus").SetDialogVariable("Bonus", Players.GetCurrentUpgradeBonus(upgradeName,playerID));

    $("#LumberCost").text = Players.GetUpgradeLumberCost(upgradeName,level)
    $("#CostContainer").visible = level != Players.GetMaxUpgradeLevel(upgradeName)
}