"use strict";


(function()
{

	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()

	var func  = function() {
		$.Schedule(0.03,func)
		var scoreboard = dotaHud.FindChildTraverse("scoreboard")
		$.DispatchEvent("DOTACustomUI_SetFlyoutScoreboardVisible", !scoreboard.BHasClass("ScoreboardClosed"))
	}
	func()

	dotaHud.FindChildTraverse("courier").style.visibility = "collapse";
	dotaHud.FindChildTraverse("CommonItems").style.visibility = "collapse";
	dotaHud.FindChildTraverse("QuickBuySlot8").style.visibility = "collapse";
	dotaHud.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
	dotaHud.FindChildTraverse("quickstats").style.visibility = "collapse";
	
	dotaHud.FindChildTraverse("StatBranch").style.visibility = "collapse";
	dotaHud.FindChildTraverse("StatBranchChannel").style.visibility = "collapse";
	dotaHud.FindChildTraverse("level_stats_frame").style.visibility = "collapse";
	dotaHud.FindChildTraverse("StatBranchHotkey").style.visibility = "collapse";
	dotaHud.FindChildTraverse("StatBranchDrawer").style.visibility = "collapse";
	dotaHud.FindChildTraverse("DOTAStatBranch").style.visibility = "collapse";



	var onPreGame = function() {
		if ( Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_GAME_IN_PROGRESS) ) {
			var abilitiesContainer = dotaHud.FindChildTraverse("abilities")
			var ultAbi = abilitiesContainer.FindChildTraverse("Ability4")
			var plusAbi = abilitiesContainer.FindChildTraverse("Ability3")
			if (ultAbi != null)
				abilitiesContainer.MoveChildBefore(ultAbi,plusAbi)
			else
				$.Schedule(1,onPreGame)
		}
	}

	GameEvents.Subscribe( "game_rules_state_change", onPreGame );

	var onUpdateHeroSelection = function() {
		var heroPickAbi = dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroAbilities")
		for (var panel of heroPickAbi.Children()) {
			if ( panel.BHasClass("StatBranch") )
				panel.style.visibility = "collapse";
		}

		var ultAbi = heroPickAbi.GetChild(4)
		var plusAbi = heroPickAbi.GetChild(3)
		heroPickAbi.MoveChildBefore(ultAbi,plusAbi)
	}

	GameEvents.Subscribe( "dota_player_hero_selection_dirty", onUpdateHeroSelection );

	//Valve can`t fix, but I can)
	$.Schedule(1,ValvePlzFix)

})();

function ValvePlzFix()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()
	
	var iconFixer = function() 
	{
		$.Schedule(0.1,iconFixer)

		if ( Game.GameStateIsAfter(DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME-1) )
		{
			var inventory = dotaHud.FindChildTraverse("inventory_list_container")
			for (var i = 0; i <= 5; i++) {
				var item = inventory.FindChildTraverse("inventory_slot_"+i)
				FixItemIcon(item)
			}

			var backpack = dotaHud.FindChildTraverse("inventory_backpack_list")
			for (var i = 6; i <= 8; i++) {
				var item = backpack.FindChildTraverse("inventory_slot_"+i)
				FixItemIcon(item)
			}

			var abilitiesPanel = dotaHud.FindChildTraverse("center_with_stats").FindChildTraverse("abilities")
			var childrens = abilitiesPanel.Children()
			for (var ability of childrens) {
				FixAbilityIcon(ability)
			}

			var shop = dotaHud.FindChildTraverse("shop")
			
			if ( shop.BHasClass("ShopOpen") )
			{ 	
				var shopCombines = shop.FindChildTraverse("ItemCombines").FindChildTraverse("ItemsContainer")
				var childrens = shopCombines.Children()
				for (var item of childrens) 
					FixItemIcon(item)

				var shopItemBuild = shop.FindChildTraverse("Categories")
				var childrens = shopItemBuild.Children()
				for (var category of childrens) {
					var childrensCat = category.FindChildTraverse("ItemList").Children()
					for (var item of childrensCat) 
						FixItemIcon(item)

				}
				
				var popularItems = shopItemBuild.GetChild(4)
				if (popularItems != null)
					popularItems.style.visibility = "collapse"


			}
		}
		else
		{

		}


		//var buffs = dotaHud.FindChildTraverse("buffs")
		//var buff0 = buffs.FindChildTraverse("Buff0")
		//$.Msg(buff0)


		var tooltipManager = dotaHud.FindChildTraverse("Tooltips")
		FixItemIcon(tooltipManager)
	}
	iconFixer()



	var shopMain = dotaHud.FindChildTraverse("shop").FindChildTraverse("GridMainShopContents")

	var shopMainBasic = shopMain.FindChildTraverse("GridBasicItems")
	var childrens = shopMainBasic.Children()
	for (var category of childrens) {
		var childrensCat = category.Children()
		for (var item of childrensCat) 
			FixItemIcon(item)		
	}

	var shopMainUpgrades = shopMain.FindChildTraverse("GridUpgradeItems")
	var childrens = shopMainUpgrades.Children()
	for (var category of childrens) {
		var childrensCat = category.Children()
		for (var item of childrensCat) 
			FixItemIcon(item)		
	}
}

function FixAbilityIcon(abilityPanel)
{
	var valveImage = abilityPanel.FindChildTraverse("AbilityImage")

	if (valveImage == null) 
		return

	var texture =  Abilities.GetAbilityTextureName(valveImage.contextEntityIndex)
	//$.Msg(texture)

	valveImage.SetImage("file://{images}/spellicons/"+texture+".png")
}

function FixItemIcon(abilityPanel)
{
	var valveImage = abilityPanel.FindChildTraverse("ItemImage")

	if (valveImage == null) 
		return 
	//valveImage.visible = false
	


	var itemName = valveImage.itemname
	//$.Msg(itemName)
	if ( itemName !== undefined)
		//$.Msg(itemName)
		itemName = itemName.replace("item_","")
	//$.Msg(itemName)
	
	if (itemName.search("recipe") != -1)
		valveImage.SetImage("file://{images}/items/recipe.png")
	else 
		valveImage.SetImage("file://{images}/items/"+itemName+".png")
}

