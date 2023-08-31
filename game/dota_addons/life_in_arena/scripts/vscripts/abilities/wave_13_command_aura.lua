wave_13_command_aura = class({})
LinkLuaModifier("modifier_wave_13_command_aura", "abilities/modifier_wave_13_command_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_13_command_aura_effect", "abilities/modifier_wave_13_command_aura", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function wave_13_command_aura:GetIntrinsicModifierName()
	return "modifier_wave_13_command_aura"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
