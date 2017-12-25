
modifier_wanderer_arcane_aura_effect = class({})

function modifier_wanderer_arcane_aura_effect:IsHidden()
	return false
end

function modifier_wanderer_arcane_aura_effect:IsPurgable()
	return false
end

function modifier_wanderer_arcane_aura_effect:OnCreated(kv)
	self.regen_mana_constant = self:GetAbility():GetSpecialValueFor("regen_mana_constant")
	self.regen_mana_percent = self:GetAbility():GetSpecialValueFor("regen_mana_percent")
end

function modifier_wanderer_arcane_aura_effect:OnRefresh(kv)
	self.regen_mana_constant = self:GetAbility():GetSpecialValueFor("regen_mana_constant")
	self.regen_mana_percent = self:GetAbility():GetSpecialValueFor("regen_mana_percent")
end

function modifier_wanderer_arcane_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
 
	return funcs
end

function modifier_wanderer_arcane_aura_effect:GetModifierTotalPercentageManaRegen()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.regen_mana_percent
end

function modifier_wanderer_arcane_aura_effect:GetModifierConstantManaRegen()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.regen_mana_constant
end