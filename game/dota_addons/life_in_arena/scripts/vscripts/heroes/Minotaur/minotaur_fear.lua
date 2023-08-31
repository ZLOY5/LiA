minotaur_fear = class({})
LinkLuaModifier("modifier_minotaur_fear_aura","heroes/Minotaur/modifier_minotaur_fear_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_minotaur_fear_effect","heroes/Minotaur/modifier_minotaur_fear_effect.lua",LUA_MODIFIER_MOTION_NONE)

function minotaur_fear:GetIntrinsicModifierName()
	return "modifier_minotaur_fear_aura"
end

