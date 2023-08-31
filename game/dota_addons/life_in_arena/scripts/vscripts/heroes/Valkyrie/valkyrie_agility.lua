valkyrie_agility = class({})
LinkLuaModifier("modifier_valkyrie_agility_aura","heroes/Valkyrie/modifier_valkyrie_agility_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_valkyrie_agility_effect","heroes/Valkyrie/modifier_valkyrie_agility_effect.lua",LUA_MODIFIER_MOTION_NONE)

function valkyrie_agility:GetIntrinsicModifierName()
	return "modifier_valkyrie_agility_aura"
end

