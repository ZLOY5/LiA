modifier_pure_light_aura = class({})


function modifier_pure_light_aura:IsHidden()
	return false
end

function modifier_pure_light_aura:IsPurgable()
	return false
end

function modifier_pure_light_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_pure_light_aura:GetModifierConstantManaRegen()
	return self.manaRegenBonus
end

function modifier_pure_light_aura:GetModifierConstantHealthRegen()
	return self.healthRegenBonus
end

function modifier_pure_light_aura:OnCreated(kv)
	 self.manaRegenBonus = self:GetAbility():GetSpecialValueFor("aura_mana_regen")
	 self.healthRegenBonus = self:GetAbility():GetSpecialValueFor("aura_health_regen")
end