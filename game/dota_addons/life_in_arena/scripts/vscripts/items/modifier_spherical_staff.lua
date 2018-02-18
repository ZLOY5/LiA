
modifier_spherical_staff = class ({})


function modifier_spherical_staff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_spherical_staff:IsHidden()
	return true
end

function modifier_spherical_staff:IsPurgable()
	return false
end

function modifier_spherical_staff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER,

	}
 
	return funcs
end

function modifier_spherical_staff:GetModifierConstantManaRegen()
	return self.manaRegenBonus
end

function modifier_spherical_staff:GetModifierBonusStats_Intellect()
	return self.intBonus
end

function modifier_spherical_staff:GetModifierScepter()
	return true
end



function modifier_spherical_staff:OnCreated()
	self.manaRegenBonus = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.intBonus = self:GetAbility():GetSpecialValueFor("bonus_int")
end

