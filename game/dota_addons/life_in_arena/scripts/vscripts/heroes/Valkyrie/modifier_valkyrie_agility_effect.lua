
modifier_valkyrie_agility_effect = class({})

function modifier_valkyrie_agility_effect:IsHidden()
	return false
end

function modifier_valkyrie_agility_effect:IsPurgable()
	return false
end

function modifier_valkyrie_agility_effect:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_valkyrie_agility_effect:OnRefresh(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_valkyrie_agility_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_valkyrie_agility_effect:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_attack_speed
end
