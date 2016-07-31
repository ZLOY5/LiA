pure_light_ability = class({})
LinkLuaModifier("modifier_item_lia_pure_light", "items/modifier_item_lia_pure_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_pure_light_protection", "items/modifier_item_lia_pure_light.lua", LUA_MODIFIER_MOTION_NONE)

function pure_light_ability:GetIntrinsicModifierName() 
	return "modifier_item_lia_pure_light"
end