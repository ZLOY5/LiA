paladin_elect = class({})
LinkLuaModifier("modifier_paladin_elect_aura","heroes/Paladin/modifier_paladin_elect_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paladin_elect_effect","heroes/Paladin/modifier_paladin_elect_effect.lua",LUA_MODIFIER_MOTION_NONE)

function paladin_elect:GetIntrinsicModifierName()
	return "modifier_paladin_elect_aura"
end

