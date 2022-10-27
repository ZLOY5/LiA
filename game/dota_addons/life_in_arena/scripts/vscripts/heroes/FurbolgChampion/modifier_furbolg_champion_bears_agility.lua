modifier_furbolg_champion_bears_agility = class({})

function modifier_furbolg_champion_bears_agility:IsHidden()
	return false
end

function modifier_furbolg_champion_bears_agility:IsPurgable()
	return false
end

function modifier_furbolg_champion_bears_agility:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.health_loss_per_attack = self:GetAbility():GetSpecialValueFor("health_loss_per_attack")
	self.health_loss_limit_percentage = self:GetAbility():GetSpecialValueFor("health_loss_limit_percentage")
end

function modifier_furbolg_champion_bears_agility:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MIN_HEALTH,
	}
 
	return funcs
end

function modifier_furbolg_champion_bears_agility:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_furbolg_champion_bears_agility:GetMinHealth()
	return self:GetParent():GetMaxHealth() * self.health_loss_limit_percentage * 0.01
end

function modifier_furbolg_champion_bears_agility:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then

			local hTarget = params.target
			if hTarget ~= nil and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                local damage = {
                    victim = self:GetParent(),
                    attacker = self:GetParent(),
                    damage = self.health_loss_per_attack, 
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
					damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
                }
    
                ApplyDamage( damage )
			end
		end
	end
end

function modifier_furbolg_champion_bears_agility:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"
end

function modifier_furbolg_champion_bears_agility:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end