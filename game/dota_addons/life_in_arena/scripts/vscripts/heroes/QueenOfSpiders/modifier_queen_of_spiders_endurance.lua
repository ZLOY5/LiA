modifier_queen_of_spiders_endurance = class({})

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:OnCreated( kv )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:OnRefresh( kv )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_endurance:GetModifierConstantHealthRegen( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_health_regen
end