modifier_hermit_storm_channel = class ({})

function modifier_hermit_storm_channel:IsHidden()
	return false
end

function modifier_hermit_storm_channel:IsPurgable()
	return false
end

function modifier_hermit_storm_channel:OnCreated(kv)
	if IsServer() then
		self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()
		self.target_point = self.ability.target_point
		
		self.wave_interval = 1 / self.ability:GetSpecialValueFor( "waves_per_second" )
		self.wave_speed = self.ability:GetSpecialValueFor( "wave_speed" )
		self.wave_width = self.ability:GetSpecialValueFor( "wave_width" )
		self.vision_aoe = self.ability:GetSpecialValueFor( "vision_aoe" )
		self.radius = self.ability:GetSpecialValueFor( "radius" )
		
		-- Get random point
		

	
		self:StartIntervalThink(self.wave_interval)
	end
end

function modifier_hermit_storm_channel:OnIntervalThink()
	if IsServer() then
		self.castPoint = self.caster:GetAbsOrigin()
		self.castDistance = RandomInt( -self.radius, self.radius )
		self.angle = math.atan2(self.target_point.y - self.castPoint.y, self.target_point.x - self.castPoint.x)
		self.dx = self.castPoint.x - 0.5 * (self.vision_aoe * math.cos(self.angle) - self.castDistance * math.sin(self.angle))
		self.dy = self.castPoint.y - 0.5 * (self.vision_aoe * math.sin(self.angle) + self.castDistance * math.cos(self.angle))
		self.attackPoint = Vector(self.dx,self.dy)

		self.info = {
			Ability = self.ability,
			EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
			Source = self.caster,
			vSpawnOrigin = self.attackPoint,
			vVelocity = self.caster:GetForwardVector() * self.wave_speed,
			fDistance = self.radius,
			--fExpireTime = GameRules:GetGameTime() + ti,
			fMoveSpeed = self.wave_speed,
			fStartRadius = self.wave_width,
			fEndRadius = self.wave_width,
			bHasFrontalCone = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			bProvidesVision = true,
			fVisionRadius = self.vision_aoe,
			iVisionTeamNumber = self.caster:GetTeamNumber(),
			--bReplaceExisting = false,
			bDeleteOnHit = true,
	    }
	    ProjectileManager:CreateLinearProjectile(self.info)
	    StartSoundEventFromPosition("Hero_Morphling.Waveform", self.attackPoint)
		
	end
end