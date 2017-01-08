"use strict";

var g_ScoreboardHandle = null;



function SetFlyoutScoreboardVisible( bVisible )
{
	if (bVisible != $.GetContextPanel().BHasClass("flyout_scoreboard_visible"))
		$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible",bVisible);
}

function ScheduledUpdate()
{
	OnUpdatePlayerData()
	$.Schedule(0.25,ScheduledUpdate)
	//$.Msg("ScheduledUpdateScoreboard")
}

function OnUpdatePlayerData( data )
{

	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}

	var containerPanel = $( "#TeamsContainer")
	var teamPanelName = "_dynamic_team_" + DOTATeam_t.DOTA_TEAM_GOODGUYS;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
		teamPanel = $.CreatePanel( "Panel",  containerPanel, teamPanelName );
		teamPanel.BLoadLayout( g_ScoreboardHandle.scoreboardConfig.teamXmlName, false, false);
	}

	
	var teamPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	//$.Msg( "                  OnUpdAction:playersContainer ", playersContainer );
	if ( playersContainer )
	{
		
		for (var playerID of teamPlayers) {
			
			_ScoreboardUpdater_UpdatePlayerPanel( g_ScoreboardHandle.scoreboardConfig, playersContainer, playerID, localPlayerTeamId ); 
		
		}
		
	}

}

(function()
{
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/lia_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" )); // 
	
	//SetFlyoutScoreboardVisible( false );

	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
	CustomNetTables.SubscribeNetTableListener("lia_player_table",OnUpdatePlayerData)

	$.Schedule(0.25,ScheduledUpdate)

	OnUpdatePlayerData()
	//

	var func  = function() {
		$.Schedule(0.03,func)
		var scoreboard = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("scoreboard")
		$.DispatchEvent("DOTACustomUI_SetFlyoutScoreboardVisible", !scoreboard.BHasClass("ScoreboardClosed"))
	}
	func()

	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("courier").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CommonItems").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("QuickBuySlot8").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("quickstats").style.visibility = "collapse";
	
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranchChannel").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("level_stats_frame").style.visibility = "collapse";
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranch").ClearPanelEvent("onmouseover")
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranch").ClearPanelEvent("onactivate")



	//Valve can`t fix, but I can)
	$.Schedule(1,ValvePlzFix)

})();

function ValvePlzFix()
{
	var iconFixer = function() 
	{
		$.Schedule(0.2,iconFixer)
		
		var inventory = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory_list_container")
		for (var i = 0; i <= 5; i++) {
			var item = inventory.FindChildTraverse("inventory_slot_"+i)
			FixItemIcon(item)
		}

		var backpack = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory_backpack_list")
		for (var i = 6; i <= 8; i++) {
			var item = backpack.FindChildTraverse("inventory_slot_"+i)
			FixItemIcon(item)
		}

		var shopCombines = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop").FindChildTraverse("ItemCombines").FindChildTraverse("ItemsContainer")
		var childrens = shopCombines.Children()
		for (var item of childrens) 
			FixItemIcon(item)

		var shopItemBuild = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop").FindChildTraverse("Categories")
		var childrens = shopItemBuild.Children()
		for (var category of childrens) {
			var childrensCat = category.FindChildTraverse("ItemList").Children()
			for (var item of childrensCat) 
				FixItemIcon(item)
		}

		//var abilitiesPanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("center_with_stats").FindChildTraverse("abilities")
		//var childrens = abilitiesPanel.Children()
		//for (var ability of childrens) {
		//	FixAbilityIcon(ability)
		//}


		var tooltipManager = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Tooltips")
		FixItemIcon(tooltipManager)
	}
	iconFixer()



	var shopMain = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop").FindChildTraverse("GridFlyoutMainShopContents")

	var shopMainBasic = shopMain.FindChildTraverse("GridFlyoutBasicItems")
	var childrens = shopMainBasic.Children()
	for (var category of childrens) {
		var childrensCat = category.Children()
		for (var item of childrensCat) 
			FixItemIcon(item)		
	}

	var shopMainUpgrades = shopMain.FindChildTraverse("GridFlyoutUpgradeItems")
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
	//$.Msg(valveImage)

	valveImage.visible = false
	
	var image = abilityPanel.FindChildTraverse("FixedIcon")
	if (image == null) {
		valveImage.GetParent().BCreateChildren("<Image id='FixedIcon' />")
		image = abilityPanel.FindChildTraverse("FixedIcon")
	}
	image.style.zIndex = "-1"
	image.style.margin = "7px"

	image.style.saturation = 1
	if (abilityPanel.BHasClass("no_level")) {
		//$.Msg(Abilities.GetAbilityName(valveImage.contextEntityIndex))
		image.style.saturation = 0
		image.SetHasClass("no_level", true)
	}
	
	var texture =  Abilities.GetAbilityTextureName(valveImage.contextEntityIndex)
	//$.Msg(texture)
	
	image.SetImage("file://{images}/spellicons/"+texture+".png")
}

function FixItemIcon(abilityPanel)
{
	var valveImage = abilityPanel.FindChildTraverse("ItemImage")

	if (valveImage === null) 
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