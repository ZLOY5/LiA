berserker_desperation = class({})
LinkLuaModifier("modifier_berserker_desperation_aura","heroes/Berserker/modifier_berserker_desperation_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_berserker_desperation_effect","heroes/Berserker/modifier_berserker_desperation_effect.lua",LUA_MODIFIER_MOTION_NONE)

function berserker_desperation:GetIntrinsicModifierName()
	return "modifier_berserker_desperation_aura"
end