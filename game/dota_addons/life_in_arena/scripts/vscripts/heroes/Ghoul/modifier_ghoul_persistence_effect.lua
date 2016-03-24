modifier_ghoul_persistence_effect = class({})

function modifier_ghoul_persistence_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_ghoul_persistence_effect:GetModifierConstantHealthRegen(params)
	return self.regen_mult * self:GetCaster():GetBaseStrength()
end

function modifier_ghoul_persistence_effect:OnCreated( kv )
	self.regen_mult = self:GetAbility():GetSpecialValueFor( "regen_mult" )
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence_effect:OnRefresh( kv )
	self.regen_mult = self:GetAbility():GetSpecialValueFor( "regen_mult" )
end