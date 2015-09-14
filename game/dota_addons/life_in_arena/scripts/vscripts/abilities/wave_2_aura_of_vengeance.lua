wave_2_aura_of_vengeance = class({})

LinkLuaModifier("modifier_wave_2_aura_of_vengeance", "abilities/modifier_wave_2_aura_of_vengeance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_2_aura_of_vengeance_aura", "abilities/modifier_wave_2_aura_of_vengeance_aura.lua", LUA_MODIFIER_MOTION_NONE)

function wave_2_aura_of_vengeance:GetIntrinsicModifierName()
	return "modifier_wave_2_aura_of_vengeance"
end

