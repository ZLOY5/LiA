item_lia_enchanted_shield = class({})
item_lia_enchanted_shield_2 = item_lia_enchanted_shield
LinkLuaModifier("modifier_item_lia_enchanted_shield", "items/modifier_item_lia_enchanted_shield.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_enchanted_shield:GetIntrinsicModifierName() 
	return "modifier_item_lia_enchanted_shield"
end