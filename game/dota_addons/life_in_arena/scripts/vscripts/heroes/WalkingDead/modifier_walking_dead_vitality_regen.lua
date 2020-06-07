
modifier_walking_dead_vitality_regen = class({})

function modifier_walking_dead_vitality_regen:IsHidden()
	return false
end

function modifier_walking_dead_vitality_regen:IsPurgable()
	return false
end

function modifier_walking_dead_vitality_regen:OnCreated(kv)
	self.health_regeneration = self:GetAbility():GetSpecialValueFor("health_regeneration")
end

function modifier_walking_dead_vitality_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_walking_dead_vitality_regen:GetModifierConstantHealthRegen()
	return self.health_regeneration
end

