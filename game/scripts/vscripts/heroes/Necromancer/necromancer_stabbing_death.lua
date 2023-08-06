necromancer_stabbing_death = class({})
LinkLuaModifier("modifier_necromancer_stabbing_death_motion", "heroes/Necromancer/modifier_necromancer_stabbing_death_motion.lua", LUA_MODIFIER_MOTION_VERTICAL)

function necromancer_stabbing_death:GetManaCost( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function necromancer_stabbing_death:OnSpellStart()
	if IsServer() then
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.length = self:GetSpecialValueFor( "length" )
		self.speed = self:GetSpecialValueFor( "speed" )
		self.width = self:GetSpecialValueFor( "width" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )

		self.speed = self.speed * ( self.length / ( self.length - self.width ) )

		local info = {
			EffectName = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.width,
			fEndRadius = self.width,
			vVelocity = vDirection * self.speed,
			fDistance = self.length,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_NyxAssassin.Impale" , self:GetCaster() )
	end
end

function necromancer_stabbing_death:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			local kv =
			{
				vLocX = hTarget:GetOrigin().x,
				vLocY = hTarget:GetOrigin().y,
				vLocZ = hTarget:GetOrigin().z
			}

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_necromancer_stabbing_death_motion", kv )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )

			local particleName = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf"
			self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
			ParticleManager:SetParticleControl( self.FXIndex, 0, hTarget:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(self.FXIndex)

			EmitSoundOn( "Hero_NyxAssassin.Impale.Target" , hTarget )
		end

		return false
	end
end