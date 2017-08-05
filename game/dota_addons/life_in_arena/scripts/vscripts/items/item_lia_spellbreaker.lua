item_lia_spellbreaker = class({})
LinkLuaModifier("modifier_spellbreaker", "items/modifier_spellbreaker.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_spellbreaker:GetIntrinsicModifierName() 
	return "modifier_spellbreaker"
end