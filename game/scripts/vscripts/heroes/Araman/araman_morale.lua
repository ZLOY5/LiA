araman_morale = class({})
LinkLuaModifier("modifier_araman_morale_aura","heroes/Araman/modifier_araman_morale_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_araman_morale_effect","heroes/Araman/modifier_araman_morale_effect.lua",LUA_MODIFIER_MOTION_NONE)

function araman_morale:GetIntrinsicModifierName()
	return "modifier_araman_morale_aura"
end

