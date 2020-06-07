modifier_walking_dead_decay_self = class ({})

function modifier_walking_dead_decay_self:IsHidden()
	return false
end

function modifier_walking_dead_decay_self:IsPurgable()
	return false
end

function modifier_walking_dead_decay_self:IsAura()
	return true
end

function modifier_walking_dead_decay_self:GetModifierAura()
	return "modifier_walking_dead_decay_debuff"
end

function modifier_walking_dead_decay_self:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_walking_dead_decay_self:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_walking_dead_decay_self:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_walking_dead_decay_self:GetAuraRadius()
	return self.radius
end


function modifier_walking_dead_decay_self:OnCreated(kv)
	self.caster = self:GetCaster()	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
	self.active_regeneration_reduction_percentage = self:GetAbility():GetSpecialValueFor("active_regeneration_reduction_percentage")
	self.damage_per_second = self:GetAbility():GetSpecialValueFor("damage_per_second")
	if IsServer() then
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_walking_dead_decay_self:OnDestroy()
	if self:GetAbility():GetToggleState() then
		self:GetAbility():ToggleAbility()
	end
end
 
function modifier_walking_dead_decay_self:GetEffectName()
	return "particles/custom/walking_dead/walking_dead_decay.vpcf"	
end

function modifier_walking_dead_decay_self:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_walking_dead_decay_self:OnIntervalThink()
	if IsServer() then
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
											self:GetParent():GetAbsOrigin(), 
											nil, self.radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, 
											false)

		for k,v in pairs (targets) do
			ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
		end 
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
	end
end

function modifier_walking_dead_decay_self:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
 
	return funcs

end

function modifier_walking_dead_decay_self:GetModifierHPRegenAmplify_Percentage()
	return self.active_regeneration_reduction_percentage
end