
modifier_kret_lust_for_life = class({})

function modifier_kret_lust_for_life:IsHidden()
	return true
end

function modifier_kret_lust_for_life:IsPurgable()
	return false
end

function modifier_kret_lust_for_life:OnCreated(kv)
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.health_threshold = self:GetAbility():GetSpecialValueFor("health_threshold")
	self.health_regen_percent = self:GetAbility():GetSpecialValueFor("health_regen_percent")
end

function modifier_kret_lust_for_life:OnRefresh(kv)
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.health_threshold = self:GetAbility():GetSpecialValueFor("health_threshold")
	self.health_regen_percent = self:GetAbility():GetSpecialValueFor("health_regen_percent")
end

function modifier_kret_lust_for_life:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
 
	return funcs
end

function modifier_kret_lust_for_life:GetModifierHealthRegenPercentage()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	local caster = self:GetParent()
	local healthPercent = caster:GetHealthPercent()
	local regen = ( 100 - healthPercent ) * self.health_regen_percent * (1 / self.health_threshold)

	return regen
end

function modifier_kret_lust_for_life:GetModifierHealthBonus()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.bonus_health
end