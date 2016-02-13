"use strict";

function ItemShowTooltip0()
{
	var c = 0;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip0()
{
	var c = 0;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip1()
{
	var c = 1;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip1()
{
	var c = 1;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip2()
{
	var c = 2;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip2()
{
	var c = 2;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip3()
{

	var c = 3;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip3()
{
	var c = 3;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip4()
{
	var c = 4;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip4()
{
	var c = 4;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}

function ItemShowTooltip5()
{
	var c = 5;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	var playerId = panel.GetAttributeInt( "playerId", -1);
	var heroEntId = Players.GetPlayerHeroEntityIndex(playerId);
	var itemEntId = Entities.GetItemInSlot(heroEntId,c);
	if (itemEntId !== -1)
	{
		var itemName = Abilities.GetAbilityName( itemEntId );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", panel, panel.itemName, heroEntId );
	}
}

function ItemHideTooltip5()
{
	var c = 5;
	var panel = $.GetContextPanel().FindChildInLayoutFile( "_dynamic_item_"+c );   
	$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
}



(function()
{
	
})();

