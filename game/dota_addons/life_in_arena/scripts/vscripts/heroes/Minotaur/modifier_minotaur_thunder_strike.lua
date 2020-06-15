modifier_minotaur_thunder_strike = class({})

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:OnCreated( kv )
	self.movespeed_slow_percentage = self:GetAbility():GetSpecialValueFor( "movespeed_slow_percentage" )
	self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow_percentage
end

--------------------------------------------------------------------------------

function modifier_minotaur_thunder_strike:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end