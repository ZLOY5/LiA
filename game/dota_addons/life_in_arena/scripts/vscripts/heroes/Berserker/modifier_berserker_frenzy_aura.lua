modifier_berserker_frenzy_aura = class({})

function modifier_berserker_frenzy_aura:IsHidden()
	return true
end

function modifier_berserker_frenzy_aura:IsPurgable()
	return false
end

function modifier_berserker_frenzy_aura:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_berserker_frenzy_aura:OnRefresh(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_berserker_frenzy_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end

function modifier_berserker_frenzy_aura:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.bonus_attack_speed
end

function modifier_berserker_frenzy_aura:GetModifierPreAttack_BonusDamage()
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	
	return self.bonus_damage
end