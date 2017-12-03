"use strict";


(function()
{

	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()

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

	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroRoles").FindChildTraverse("Role_Carry").style.visibility = "collapse"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroRoles").FindChildTraverse("Role_Support").style.visibility = "collapse"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroRoles").FindChildTraverse("Role_Initiator").style.visibility = "collapse"

	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroFilters").FindChildTraverse("BottomLineFilters").FindChildTraverse("RoleOptions").style.visibility = "collapse"
	dotaHud.FindChildTraverse("PreGame").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroFilters").FindChildTraverse("AttributeOptions").GetChild(6).style.visibility = "collapse"
	
	$.Schedule(1,ValvePlzFix)


})();

function ValvePlzFix()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()


	
	var iconFixer = function() 
	{
		$.Schedule(0.1,iconFixer)

		dotaHud.FindChildTraverse("lower_hud").FindChildTraverse("StatBranch").style.visibility = "collapse";
		dotaHud.FindChildTraverse("level_stats_frame").style.visibility = "collapse";
		dotaHud.FindChildTraverse("StatBranchHotkey").style.visibility = "collapse";
		dotaHud.FindChildTraverse("StatBranchDrawer").style.visibility = "collapse";
		dotaHud.FindChildTraverse("DOTAStatBranch").style.visibility = "collapse";
		

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

				var baseHealthRegen = Number(statsTooltip.FindChildTraverse("HealthRegen").text)
				
				var healthBonus = strength*8
				var healthRegenBouns = strength*5
				//$.Msg(strength)
				statsTooltip.FindChildTraverse("StrengthDetails").SetDialogVariableInt("strength_hp", healthBonus)
				statsTooltip.FindChildTraverse("StrengthDetails").SetDialogVariable("strength_hp_regen", healthRegenBouns.toFixed(1))

				statsTooltip.FindChildTraverse("StrengthDamageLabel").SetDialogVariableInt("primary_attribute_damage", strength*1.5)
				
			}

			var bonusAgi = Number(statsTooltip.FindChildTraverse("BonusAgilityabel").text.replace(" + ",""))
			var agility = Number(statsTooltip.FindChildTraverse("BaseAgilityLabel").text )
			
			if (!isNaN(agility)) {
				if (!statsTooltip.FindChildTraverse("AgilityContainer").BHasClass("NoBonus"))
					agility = agility + bonusAgi
				
				statsTooltip.FindChildTraverse("AgilityDetails").SetDialogVariable("agility_armor", (agility/6).toFixed(1))

				statsTooltip.FindChildTraverse("AgilityDamageLabel").SetDialogVariableInt("primary_attribute_damage", agility*1.5)
			}

			var bonusInt = Number(statsTooltip.FindChildTraverse("BonusIntelligenceLabel").text.replace(" + ",""))
			var intellect = Number(statsTooltip.FindChildTraverse("BaseIntelligenceLabel").text )
			
			if (!isNaN(intellect)) {
				if (!statsTooltip.FindChildTraverse("IntelligenceContainer").BHasClass("NoBonus"))
					intellect = intellect + bonusInt
				
				var baseManaRegen = Number(statsTooltip.FindChildTraverse("ManaRegen").text)
				var manaRegenBouns = intellect*5

				statsTooltip.FindChildTraverse("IntelligenceDetails").SetDialogVariable("intelligence_mana_regen", manaRegenBouns.toFixed(1))

				statsTooltip.FindChildTraverse("IntelligenceDamageLabel").SetDialogVariableInt("primary_attribute_damage", intellect*1.5)
			}
		}
	}
	iconFixer()
}



