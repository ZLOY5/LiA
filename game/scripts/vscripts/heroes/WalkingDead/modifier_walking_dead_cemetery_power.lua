modifier_walking_dead_cemetery_power = class ({})

function modifier_walking_dead_cemetery_power:IsHidden()
	return false
end

function modifier_walking_dead_cemetery_power:IsPurgable()
	return false
end


function modifier_walking_dead_cemetery_power:OnCreated(kv)
	self.caster = self:GetCaster()	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_base_strength = self:GetAbility():GetSpecialValueFor("bonus_base_strength")
	self.heal_to_damage_percentage = self:GetAbility():GetSpecialValueFor("heal_to_damage_percentage")
	self.damage_accumulation = 0
	if IsServer() then
		self:StartIntervalThink(1)

		for i = 1,10 do
			Timers:CreateTimer({
		            useGameTime = false,
		            endTime = 0.1 * i,
		            callback = function()
						self.caster:ModifyStrength(0.1 * self.bonus_base_strength)
		            end
		          })
		end
	end
end
 
function modifier_walking_dead_cemetery_power:GetEffectName()
	return "particles/units/heroes/hero_undying/undying_fg_aura2.vpcf"	
end

function modifier_walking_dead_cemetery_power:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- function modifier_walking_dead_cemetery_power:OnIntervalThink()
-- 	if IsServer() then
-- 		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
-- 											self:GetParent():GetAbsOrigin(), 
-- 											nil, self.radius, 
-- 											DOTA_UNIT_TARGET_TEAM_ENEMY, 
-- 											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
-- 											DOTA_UNIT_TARGET_FLAG_NONE, 
-- 											FIND_ANY_ORDER, 
-- 											false)

-- 		for k,v in pairs (targets) do
-- 			ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
-- 		end 
-- 		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
-- 	end
-- end

function modifier_walking_dead_cemetery_power:OnIntervalThink()

	local damage = self.damage_accumulation * self.heal_to_damage_percentage * 0.01

	if damage == 0 then return end

	self.damage_accumulation = 0

	
	local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
											self:GetParent():GetAbsOrigin(), 
											nil, self.radius, 
											DOTA_UNIT_TARGET_TEAM_ENEMY, 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, 
											false)

	for k,v in pairs (targets) do
		ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
		self.cemeteryPowerHitParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf",PATTACH_ABSORIGIN_FOLLOW,v)
		ParticleManager:SetParticleControl( self.cemeteryPowerHitParticle, 1, v:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.cemeteryPowerHitParticle, 0, v:GetAbsOrigin() )
	end 
	self.caster:EmitSound("Hero_Undying.FleshGolem.End")
end

function modifier_walking_dead_cemetery_power:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
	}
 
	return funcs

end


function modifier_walking_dead_cemetery_power:OnHealReceived(params)
	if self:GetParent():GetHealthPercent() == 100 then return end
	self.damage_accumulation = self.damage_accumulation + params.gain
end


function modifier_walking_dead_cemetery_power:OnDestroy()
	if IsServer() then
		for i = 1,10 do
			Timers:CreateTimer({
		            useGameTime = false,
		            endTime = 0.1 * i,
		            callback = function()
						self.caster:ModifyStrength(-(0.1 * self.bonus_base_strength))
		            end
		          })
		end
		self.caster:EmitSound("Hero_Undying.FleshGolem.End")
	end
end


