modifier_witch_doctor_frost_armor_debuff = class({})

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:OnCreated( kv )
	self.movement_slow_percent = self:GetAbility():GetSpecialValueFor( "movement_slow_percent" )
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percent
end

--------------------------------------------------------------------------------

function modifier_witch_doctor_frost_armor_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end