modifier_pirate_evasion = class({})

--------------------------------------------------------------------------------

function modifier_pirate_evasion:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pirate_evasion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pirate_evasion:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

--------------------------------------------------------------------------------

function modifier_pirate_evasion:OnRefresh( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

--------------------------------------------------------------------------------

function modifier_pirate_evasion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_pirate_evasion:GetModifierEvasion_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.evasion
end