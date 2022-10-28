modifier_huntress_power_of_the_moon = class({})

function modifier_huntress_power_of_the_moon:IsHidden()
	return true
end

function modifier_huntress_power_of_the_moon:IsPurgable()
	return false
end

function modifier_huntress_power_of_the_moon:OnCreated(kv)
	self.bonus_magic_resistance_percentage = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance_percentage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_movement_speed_percentage = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_percentage")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_huntress_power_of_the_moon:OnRefresh(kv)
	self.bonus_magic_resistance_percentage = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance_percentage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_movement_speed_percentage = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_percentage")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_huntress_power_of_the_moon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
 
	return funcs
end

function modifier_huntress_power_of_the_moon:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resistance_percentage
end

function modifier_huntress_power_of_the_moon:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_huntress_power_of_the_moon:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movement_speed_percentage
end

function modifier_huntress_power_of_the_moon:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

