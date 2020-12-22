"use strict";

var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent();


(function()
{

	/*var func  = function() {
		$.Schedule(0.03,func)
		var scoreboard = dotaHud.FindChildTraverse("scoreboard")
		$.DispatchEvent("DOTACustomUI_SetFlyoutScoreboardVisible", !scoreboard.BHasClass("ScoreboardClosed"))
	}
	func()*/

	dotaHud.FindChildTraverse("GameInfoButton").style.visibility = "collapse";

	dotaHud.FindChildTraverse("courier").style.visibility = "collapse";
	dotaHud.FindChildTraverse("CommonItems").style.visibility = "collapse";
	dotaHud.FindChildTraverse("QuickBuySlot8").style.visibility = "collapse";
	dotaHud.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
	dotaHud.FindChildTraverse("quickstats").style.visibility = "collapse";

	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeaderCenter").style.marginLeft = "1150px"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("TeamPurchasesStrategyControl").style.visibility = "collapse";

	var onUpdateHeroSelection = function(data) {
		//$.Msg(data)
		var heroPickAbi = dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroAbilities")
		for (var panel of heroPickAbi.Children()) {
			if ( panel.BHasClass("StatBranch") )
				panel.style.visibility = "collapse";
		}

		var ultAbi = heroPickAbi.GetChild(4)
		var plusAbi = heroPickAbi.GetChild(3)
		if ( (ultAbi != null) && (ultAbi.BHasClass("AbilityIsUltimate")) )
			heroPickAbi.MoveChildBefore(ultAbi,plusAbi)
	}

	GameEvents.Subscribe( "dota_player_hero_selection_dirty", onUpdateHeroSelection );

    
	var randomHeroButton = dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("RandomButton")
	randomHeroButton.style.saturation = 1
	randomHeroButton.style.brightness = 1
	randomHeroButton.SetPanelEvent("onactivate", function() { GameEvents.SendCustomGameEventToServer( "lia_random_hero", {} ) } )
	randomHeroButton.SetPanelEvent("onmouseover", 
		function() { 
			randomHeroButton.ClearPropertyFromCode("brightness") 
			randomHeroButton.style.brightness = 1.5 
		} )
	randomHeroButton.SetPanelEvent("onmouseout", 
		function() { 
			randomHeroButton.ClearPropertyFromCode("brightness") 
			randomHeroButton.style.brightness = 1 
		} )

	var reRandomHeroButton = dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("ReRandomButton")
	reRandomHeroButton.SetPanelEvent("onactivate", function() { GameEvents.SendCustomGameEventToServer( "lia_random_hero", {} ) } )

	reRandomHeroButton = dotaHud.FindChildTraverse("PreGame").FindChildTraverse("StrategyScreen").FindChildTraverse("EnterGameReRandomButton")
	reRandomHeroButton.SetPanelEvent("onactivate", function() { GameEvents.SendCustomGameEventToServer( "lia_random_hero", {} ) } )

	$.Schedule(1,ValvePlzFix)

	
})();


function ValvePlzFix()
{
	
	var iconFixer = function() 
	{
		$.Schedule(1,iconFixer)

		dotaHud.FindChildTraverse("lower_hud").FindChildTraverse("StatBranch").style.visibility = "collapse";
		dotaHud.FindChildTraverse("level_stats_frame").style.visibility = "collapse";
		dotaHud.FindChildTraverse("StatBranchHotkey").style.visibility = "collapse";
		dotaHud.FindChildTraverse("StatBranchDrawer").style.visibility = "collapse";
		dotaHud.FindChildTraverse("DOTAStatBranch").style.visibility = "collapse";

		dotaHud.FindChildTraverse("inventory_neutral_slot_container").style.visibility = "collapse";
		dotaHud.FindChildTraverse("right_flare").style.marginBottom = "-55px"
		dotaHud.FindChildTraverse("inventory_tpscroll_slot").style.boxShadow = "none"

		dotaHud.FindChildTraverse("AghsStatusContainer").style.visibility = "collapse";
		
		if ( Game.GameStateIsAfter(DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME-1) )
		{
			var shop = dotaHud.FindChildTraverse("shop")	

			shop.RemoveClass("GuidesDisabled")

			var shopItemBuild = shop.FindChildTraverse("Categories")
			var popularItems = shopItemBuild.GetChild(5)
			if (popularItems != null)
				popularItems.style.visibility = "collapse"
		}

		var tooltipManager = dotaHud.FindChildTraverse("Tooltips")
		var statsTooltip = tooltipManager.FindChildTraverse("DOTAHUDDamageArmorTooltip")

		if (statsTooltip != null) {
			var bonusStr = Number(statsTooltip.FindChildTraverse("BonusStrengthLabel").text.replace(" + ",""))
			var strength = Number(statsTooltip.FindChildTraverse("BaseStrengthLabel").text )
			
			if (!isNaN(strength)) {
				if (!statsTooltip.FindChildTraverse("StrengthContainer").BHasClass("NoBonus"))
					strength = strength + bonusStr

				statsTooltip.FindChildTraverse("StrengthDamageLabel").SetDialogVariableInt("primary_attribute_damage", strength*1.5)
				
			}

			var bonusAgi = Number(statsTooltip.FindChildTraverse("BonusAgilityabel").text.replace(" + ",""))
			var agility = Number(statsTooltip.FindChildTraverse("BaseAgilityLabel").text )
			
			if (!isNaN(agility)) {
				if (!statsTooltip.FindChildTraverse("AgilityContainer").BHasClass("NoBonus"))
					agility = agility + bonusAgi

				statsTooltip.FindChildTraverse("AgilityDamageLabel").SetDialogVariableInt("primary_attribute_damage", agility*1.5)
			}

			var bonusInt = Number(statsTooltip.FindChildTraverse("BonusIntelligenceLabel").text.replace(" + ",""))
			var intellect = Number(statsTooltip.FindChildTraverse("BaseIntelligenceLabel").text )
			
			if (!isNaN(intellect)) {
				if (!statsTooltip.FindChildTraverse("IntelligenceContainer").BHasClass("NoBonus"))
					intellect = intellect + bonusInt

				statsTooltip.FindChildTraverse("IntelligenceDamageLabel").SetDialogVariableInt("primary_attribute_damage", intellect*1.5)
			}
		}
	}
	iconFixer()
}



