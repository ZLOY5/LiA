witch_doctor_negative_energy = class({})

function witch_doctor_negative_energy:OnSpellStart()
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

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( self.projectile_distance / ( self.projectile_distance - self.start_width ) )

	local info = {
		EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf",
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
	EmitSoundOn( "Hero_ShadowDemon.ShadowPoison", self:GetCaster() )
end

function witch_doctor_negative_energy:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		if self:GetCaster():HasScepter() then
			self.damage = self:GetSpecialValueFor( "damage_scepter" )
		else
			self.damage = self:GetSpecialValueFor( "damage" )
		end

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end