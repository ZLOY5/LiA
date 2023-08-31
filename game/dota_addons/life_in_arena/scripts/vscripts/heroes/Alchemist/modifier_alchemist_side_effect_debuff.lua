
modifier_alchemist_side_effect_debuff = class({})

function modifier_alchemist_side_effect_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alchemist_side_effect_debuff:IsHidden()
	return false
end

function modifier_alchemist_side_effect_debuff:IsPurgable()
	return false
end

function modifier_alchemist_side_effect_debuff:OnCreated(kv)
	self.movespeed_slow_percentage = self:GetAbility():GetSpecialValueFor("movespeed_slow_percentage")
	self.turn_rate_slow_percentage = self:GetAbility():GetSpecialValueFor("turn_rate_slow_percentage")
end

function modifier_alchemist_side_effect_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_alchemist_side_effect_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow_percentage
end

function modifier_alchemist_side_effect_debuff:GetModifierTurnRate_Percentage()
	return self.turn_rate_slow_percentage
end