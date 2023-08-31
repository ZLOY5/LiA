modifier_staff_of_life = class({})

function modifier_staff_of_life:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_staff_of_life:IsHidden()
	return true
end

function modifier_staff_of_life:IsPurgable()
	return false
end

function modifier_staff_of_life:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_staff_of_life:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_staff_of_life:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_staff_of_life:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_staff_of_life:OnCreated(kv)
	 self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	 self.bonus_intelligence = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	 self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end