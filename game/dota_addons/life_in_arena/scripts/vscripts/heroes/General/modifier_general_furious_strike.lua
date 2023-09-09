modifier_general_furious_strike = class({})

function modifier_general_furious_strike:IsHidden()
	return true
end

function modifier_general_furious_strike:IsPurgable()
	return false
end

function modifier_general_furious_strike:OnCreated(kv)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_general_furious_strike:OnRefresh(kv)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_general_furious_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_general_furious_strike:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then

			if self:GetParent():PassivesDisabled() then
				return
			end
			
			local hTarget = params.target
			if hTarget ~= nil then

				local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
											params.target:GetAbsOrigin(), 
											nil, self.radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

				for k,v in pairs (targets) do
					ApplyDamage({ victim = v, attacker = params.attacker, damage = self.bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
				end 
				
			end
		end
	end

	return 0.0
end
