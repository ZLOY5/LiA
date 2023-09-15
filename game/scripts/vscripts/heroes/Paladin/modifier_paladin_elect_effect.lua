
modifier_paladin_elect_effect = class({})

function modifier_paladin_elect_effect:IsHidden()
	return false
end

function modifier_paladin_elect_effect:IsPurgable()
	return false
end

function modifier_paladin_elect_effect:OnCreated(kv)
	self.constant_regen = self:GetAbility():GetSpecialValueFor("constant_regen")
	self.regen_percentage = self:GetAbility():GetSpecialValueFor("regen_percentage")
end

function modifier_paladin_elect_effect:OnRefresh(kv)
	self.constant_regen = self:GetAbility():GetSpecialValueFor("constant_regen")
	self.regen_percentage = self:GetAbility():GetSpecialValueFor("regen_percentage")
end

function modifier_paladin_elect_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_paladin_elect_effect:GetModifierHealthRegenPercentage()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.regen_percentage
end

function modifier_paladin_elect_effect:GetModifierConstantHealthRegen()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.constant_regen
end