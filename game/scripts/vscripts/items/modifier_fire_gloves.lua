modifier_fire_gloves = class({})

function modifier_fire_gloves:IsPurgable()
	return false
end

function modifier_fire_gloves:IsHidden()
	return true 
end

function modifier_fire_gloves:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_fire_gloves:DeclareFunctions()
	return 	{
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		    	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_PROPERTY_MANA_BONUS
			}
end

function modifier_fire_gloves:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed
end

function modifier_fire_gloves:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage 
end

function modifier_fire_gloves:GetModifierManaBonus()
	return self.bonusMana
end

function modifier_fire_gloves:OnCreated()
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonusMana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonusAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end