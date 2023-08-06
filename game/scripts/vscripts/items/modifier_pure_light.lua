modifier_pure_light = class({})

function modifier_pure_light:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_pure_light:IsHidden()
	return true
end

function modifier_pure_light:IsPurgable()
	return false
end

function modifier_pure_light:IsAura()
	return true
end

function modifier_pure_light:GetAuraRadius()
	return self.auraRadius
end

function modifier_pure_light:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_pure_light:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_pure_light:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_pure_light:GetAuraDuration()
	return 1
end

function modifier_pure_light:GetModifierAura()
	return "modifier_pure_light_aura"
end

function modifier_pure_light:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_pure_light:GetModifierManaBonus()
	return self.manaBonus
end

function modifier_pure_light:GetModifierBonusStats_Intellect()
	return self.bonusIntellect
end

function modifier_pure_light:OnCreated(kv)
	 self.manaBonus = self:GetAbility():GetSpecialValueFor("bonus_mana")
	 self.bonusIntellect = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	 self.auraRadius = self:GetAbility():GetSpecialValueFor("aura_radius")
end