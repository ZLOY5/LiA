treant_butterfly_flock = class({})

function treant_butterfly_flock:OnSpellStart()
	self.speed = self:GetSpecialValueFor( "speed" )
	self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
	self.start_width = self:GetSpecialValueFor( "start_width" )
	self.end_width = self:GetSpecialValueFor( "end_width" )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	self.caster_position = self:GetCaster():GetOrigin()
	local vDirection = vPos - self.caster_position
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( self.projectile_distance / ( self.projectile_distance - self.start_width ) )

	local info = {
		EffectName = "particles/custom/treant/treant_butterfly_flock.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.start_width,
		fEndRadius = self.end_width,
		vVelocity = vDirection * self.speed,
		fDistance = self.projectile_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_DeathProphet.CarrionSwarm", self:GetCaster() )
end

function treant_butterfly_flock:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		self.damage = self:GetSpecialValueFor( "damage" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		local distance_from_caster = (vLocation - self.caster_position):Length2D()
		local distance_to_travel = math.abs(self.projectile_distance - distance_from_caster)
		local knockback_duration = distance_to_travel / self.speed

		local kv =
		{
			center_x = self.caster_position.x,
			center_y = self.caster_position.y,
			center_z = self.caster_position.z,
			should_stun = true, 
			duration = knockback_duration,
			knockback_distance = distance_to_travel,
		}
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback_lia", kv )

	end

	return false
end