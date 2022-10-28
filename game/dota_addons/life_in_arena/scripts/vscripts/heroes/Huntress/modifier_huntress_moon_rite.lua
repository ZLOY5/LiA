modifier_huntress_moon_rite = class({})

function modifier_huntress_moon_rite:IsHidden()
	return false
end

function modifier_huntress_moon_rite:IsPurgable()
	return false
end

function modifier_huntress_moon_rite:OnCreated(kv)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end


function modifier_huntress_moon_rite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_huntress_moon_rite:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_huntress_moon_rite:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_huntress_moon_rite:GetEffectName()
	return "particles/custom/huntress/huntress_moon_rite.vpcf"
end

function modifier_huntress_moon_rite:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


