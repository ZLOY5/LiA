modifier_araman_power_of_scourge = class ({})


function modifier_araman_power_of_scourge:IsPurgable()
	return true
end 

function modifier_araman_power_of_scourge:IsBuff()
	return true
end 

function modifier_araman_power_of_scourge:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf"
end

function modifier_araman_power_of_scourge:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------

function modifier_araman_power_of_scourge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_araman_power_of_scourge:GetModifierMoveSpeedBonus_Percentage(params)
	return self.bonus_move_speed
end

function modifier_araman_power_of_scourge:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end

function modifier_araman_power_of_scourge:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount()
end

function modifier_araman_power_of_scourge:OnCreated(params)
	self.power_of_scourge_max_stacks = self:GetAbility():GetSpecialValueFor("damage_stack_max")
	self.power_of_scourge_stacks = 0

	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_attack")
	self.bonus_damage = 0

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
end

function modifier_araman_power_of_scourge:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() and params.target:GetTeamNumber() ~= params.attacker:GetTeamNumber() then
			if self.power_of_scourge_stacks < self.power_of_scourge_max_stacks then
				self.bonus_damage = self.bonus_damage + self.damage_per_stack
				self.power_of_scourge_stacks = self.power_of_scourge_stacks + 1
				self:SetStackCount(self.bonus_damage)
			end
		end
	end
end

