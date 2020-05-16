alchemist_fire_potion = class({})

function alchemist_fire_potion:OnSpellStart()
	self.speed = self:GetSpecialValueFor( "speed" )
	self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
	self.start_width = self:GetSpecialValueFor( "start_width" )
	self.end_width = self:GetSpecialValueFor( "end_width" )
	self.self_damage = self:GetSpecialValueFor( "self_damage" )
	self.caster = self:GetCaster()

	
	if self.caster:HasScepter() then
		self.wave_count = self:GetSpecialValueFor( "wave_count_scepter" )
		self.delay_between_waves = self:GetSpecialValueFor( "delay_between_waves_scepters" )
		self.potion_count = 2
	else
		self.wave_count = self:GetSpecialValueFor( "wave_count" )
		self.delay_between_waves = self:GetSpecialValueFor( "delay_between_waves" )
		self.potion_count = 1
	end

	local hSideEffectAbility = self.caster:FindAbilityByName("alchemist_side_effect")
	if hSideEffectAbility and hSideEffectAbility:GetLevel() > 0 then
		self.caster:FindModifierByNameAndCaster("modifier_alchemist_side_effect", self.caster):IncrementPotionCount(self.potion_count)
	end

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self.caster:GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( self.projectile_distance / ( self.projectile_distance - self.start_width ) )

	local info = {
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
		Ability = self,
		vSpawnOrigin = self.caster:GetOrigin(), 
		fStartRadius = self.start_width,
		fEndRadius = self.end_width,
		vVelocity = vDirection * self.speed,
		fDistance = self.projectile_distance,
		Source = self.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	for i = 1,self.wave_count do

	end

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Jakiro.DualBreath.Cast", self.caster )

	local damage = {
		victim = self.caster,
		attacker = self.caster,
		damage = self.self_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	ApplyDamage( damage )
end

function alchemist_fire_potion:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		self.damage = self:GetSpecialValueFor( "damage" )

		local damage = {
			victim = hTarget,
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end
