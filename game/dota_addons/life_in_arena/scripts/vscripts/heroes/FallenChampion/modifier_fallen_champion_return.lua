modifier_fallen_champion_return = class({})

function modifier_fallen_champion_return:IsHidden()
	return true
end

function modifier_fallen_champion_return:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_fallen_champion_return:OnAttackLanded(params) 
	if IsServer() then
		if params.target == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") then 
			self.attack_record = params.record 
			self.ranged_attack = params.ranged_attack
		end 
	end
end


function modifier_fallen_champion_return:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") and not IsFlagSet(params.damage_flags,DOTA_DAMAGE_FLAG_REFLECTION) then
			
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local bPhys = params.damage_type == DAMAGE_TYPE_PHYSICAL
			local bRangedAttack = self.attack_record == params.record and self.ranged_attack
			if bPhys and not bRangedAttack then 
				local target = params.unit
				
				local return_damage 
				if RollPercentage(self:GetAbility():GetSpecialValueFor("full_damage_chance")) then
					return_damage = params.original_damage
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, return_damage, nil)
				else
					return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.original_damage
				end
				
				ApplyDamage(
				{
					victim = params.attacker, 
					attacker = target, 
					damage = return_damage, 
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = self:GetAbility()
				})
			end
		end
	end
end