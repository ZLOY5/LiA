berserker_fire_spear = class({})

function berserker_fire_spear:GetChannelTime()
	if self:GetCaster():HasModifier("modifier_berserker_madness") then
		return self:GetSpecialValueFor( "channel_duration_ultimate" )
	end
	return self:GetSpecialValueFor( "channel_duration" )
end

function berserker_fire_spear:OnSpellStart()
	self.caster = self:GetCaster()
	self.vPos = self:GetCursorPosition()
	
	self.base_damage = self:GetSpecialValueFor( "base_damage" )
	self.stats_sum = self.caster:GetStrength() + self.caster:GetAgility() + self.caster:GetIntellect()
end

function berserker_fire_spear:OnChannelFinish( bInterrupted )
	self.channel_percent = (GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime()

	self.attributes_damage_max_pct = self:GetSpecialValueFor( "attributes_damage_max_pct" )
	self.damage = self.base_damage + (self.stats_sum * self.attributes_damage_max_pct * self.channel_percent * 0.01)

	self.spear_speed = self:GetSpecialValueFor( "spear_speed" )
	self.spear_range = self:GetSpecialValueFor( "spear_range" )
	self.spear_width = self:GetSpecialValueFor( "spear_width" )

	self.vDirection = self.vPos - self.caster:GetOrigin()
	self.vDirection.z = 0.0
	self.vDirection = self.vDirection:Normalized()

	local info = {
		EffectName = "particles/berserker_fire_spear.vpcf",
		Ability = self,
		vSpawnOrigin = self.caster:GetOrigin(), 
		fStartRadius = self.spear_width,
		fEndRadius = self.spear_width,
		vVelocity = self.vDirection * self.spear_speed,
		fDistance = self.spear_range,
		Source = self.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Huskar.Burning_Spear", self.caster )
end

function berserker_fire_spear:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then

		local damage = {
			victim = hTarget,
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end