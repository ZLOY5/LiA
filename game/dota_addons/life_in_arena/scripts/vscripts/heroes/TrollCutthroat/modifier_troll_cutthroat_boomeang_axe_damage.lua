
modifier_troll_cutthroat_boomeang_axe_damage = class({})

function modifier_troll_cutthroat_boomeang_axe_damage:IsHidden()
	return true
end

function modifier_troll_cutthroat_boomeang_axe_damage:IsPurgable()
	return false
end

function modifier_troll_cutthroat_boomeang_axe_damage:OnCreated(kv)
	self.damage_percentage = self:GetAbility():GetSpecialValueFor("damage_percentage")
	self.strength_into_damage_percentage = self:GetAbility():GetSpecialValueFor("strength_into_damage_percentage")
end

function modifier_troll_cutthroat_boomeang_axe_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
 
	return funcs
end

function modifier_troll_cutthroat_boomeang_axe_damage:GetModifierProcAttack_BonusDamage_Physical()
	local strength_damage = self:GetParent():GetStrength() * self.strength_into_damage_percentage * 0.01

	return strength_damage
end

function modifier_troll_cutthroat_boomeang_axe_damage:GetModifierDamageOutgoing_Percentage()
	return self.damage_percentage * (-1)
end