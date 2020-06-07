
modifier_walking_dead_decay_regen = class({})

function modifier_walking_dead_decay_regen:IsHidden()
	return false
end

function modifier_walking_dead_decay_regen:IsPurgable()
	return false
end

function modifier_walking_dead_decay_regen:OnCreated(kv)
	self.health_regeneration = self:GetAbility():GetSpecialValueFor("health_regeneration")
end

function modifier_walking_dead_decay_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end


function modifier_walking_dead_decay_regen:GetModifierConstantHealthRegen()
	return self.health_regeneration
end