wave_3_evasion = class({})

LinkLuaModifier("modifier_wave_3_evasion", "abilities/wave_3_evasion.lua", LUA_MODIFIER_MOTION_NONE)

function wave_3_evasion:GetIntrinsicModifierName()
	return "modifier_wave_3_evasion"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_wave_3_evasion = class({})

--------------------------------------------------------------------------------

function modifier_wave_3_evasion:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_3_evasion:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

--------------------------------------------------------------------------------

function modifier_wave_3_evasion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_3_evasion:GetModifierEvasion_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.evasion
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

