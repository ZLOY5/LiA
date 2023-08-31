wave_16_evasion_extreme = class({})

LinkLuaModifier("modifier_wave_16_evasion_extreme", "abilities/wave_16_evasion_extreme.lua", LUA_MODIFIER_MOTION_NONE)

function wave_16_evasion_extreme:GetIntrinsicModifierName()
	return "modifier_wave_16_evasion_extreme"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_wave_16_evasion_extreme = class({})

--------------------------------------------------------------------------------

function modifier_wave_16_evasion_extreme:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_16_evasion_extreme:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

--------------------------------------------------------------------------------

function modifier_wave_16_evasion_extreme:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_16_evasion_extreme:GetModifierEvasion_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.evasion
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

