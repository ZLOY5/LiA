modifier_warlock_firestorm_channel = class ({})

function modifier_warlock_firestorm_channel:IsHidden()
	return false
end

function modifier_warlock_firestorm_channel:IsPurgable()
	return false
end

function modifier_warlock_firestorm_channel:OnCreated(kv)
	self.wave_interval = self:GetAbility():GetSpecialValueFor("wave_interval")
	self.burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
	
	if self:GetCaster():HasScepter() then
		self.wave_damage = self:GetAbility():GetSpecialValueFor( "wave_damage_scepter" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius_scepter" )
	else
		self.wave_damage = self:GetAbility():GetSpecialValueFor( "wave_damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end

	self.target_point = self:GetAbility().target_point

	if IsServer() then
		self:StartIntervalThink(self.wave_interval)
	end
end

function modifier_warlock_firestorm_channel:OnDestroy()
	if IsServer() then
		
	end
end

function modifier_warlock_firestorm_channel:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()

		local firestormTargets = FindUnitsInRadius(caster:GetTeam(), 
													self:GetAbility().target_point, 
													nil, self.radius, 
													DOTA_UNIT_TARGET_TEAM_ENEMY, 
													DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
													0, 
													FIND_ANY_ORDER, 
													false)

	    local firestorm = ParticleManager:CreateParticle("particles/custom/neutral/firestorm_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(firestorm, 0, self.target_point)
	    ParticleManager:SetParticleControl(firestorm, 4, Vector(self.radius, 1, 1))

	    caster:EmitSound("Hero_AbyssalUnderlord.Firestorm.Target")

	    for _,v in pairs(firestormTargets) do
				ApplyDamage({ victim = v, attacker = caster, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self.wave_damage })
				v:AddNewModifier(caster, self:GetAbility(), "modifier_warlock_firestorm_burn", {duration = self.burn_duration})
		end
	end
end