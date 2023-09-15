frost_lord_frost_breath = class({})
LinkLuaModifier("modifier_frost_lord_frost_breath_debuff","heroes/FrostLord/modifier_frost_lord_frost_breath_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function frost_lord_frost_breath:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end


function frost_lord_frost_breath:OnSpellStart()
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
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf",
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
	EmitSoundOn( "Hero_Jakiro.DualBreath", self:GetCaster() )
end

function frost_lord_frost_breath:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		if self:GetCaster():HasScepter() then
			self.damage = self:GetSpecialValueFor( "damage_scepter" )
			self.duration = self:GetSpecialValueFor( "duration_scepter" )
		else
			self.damage = self:GetSpecialValueFor( "damage" )
			self.duration = self:GetSpecialValueFor( "duration" )
		end

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_frost_lord_frost_breath_debuff", {duration = self.duration})
	end

	return false
end