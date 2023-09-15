modifier_berserker_desperation_effect = class({})

function modifier_berserker_desperation_effect:IsHidden()
	return false
end

function modifier_berserker_desperation_effect:IsPurgable()
	return false
end

function modifier_berserker_desperation_effect:OnCreated(kv)
	self.penalty_attack_speed = self:GetAbility():GetSpecialValueFor("penalty_attack_speed")
end

function modifier_berserker_desperation_effect:OnRefresh(kv)
	self.penalty_attack_speed = self:GetAbility():GetSpecialValueFor("penalty_attack_speed")
end

function modifier_berserker_desperation_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_berserker_desperation_effect:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.penalty_attack_speed
end
