modifier_shaman_ancient_forces = class({})

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:OnCreated( kv )
	self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor( "bonus_damage_percentage" )
end

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:OnRefresh( kv )
	self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor( "bonus_damage_percentage" )
end

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_shaman_ancient_forces:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage_percentage
end