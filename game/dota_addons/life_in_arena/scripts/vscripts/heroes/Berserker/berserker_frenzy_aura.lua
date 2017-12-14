berserker_frenzy_aura = class({})
LinkLuaModifier("modifier_berserker_frenzy_aura","heroes/Berserker/modifier_berserker_frenzy_aura.lua",LUA_MODIFIER_MOTION_NONE)

function berserker_frenzy_aura:GetIntrinsicModifierName()
	return "modifier_berserker_frenzy_aura"
end