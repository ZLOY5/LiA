wanderer_arcane_aura = class({})
LinkLuaModifier("modifier_wanderer_arcane_aura","heroes/Wanderer/modifier_wanderer_arcane_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wanderer_arcane_aura_effect","heroes/Wanderer/modifier_wanderer_arcane_aura_effect.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wanderer_arcane_aura_slow","heroes/Wanderer/modifier_wanderer_arcane_aura_slow.lua",LUA_MODIFIER_MOTION_NONE)

function wanderer_arcane_aura:GetIntrinsicModifierName()
	return "modifier_wanderer_arcane_aura"
end

