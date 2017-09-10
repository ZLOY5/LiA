second_wave_wave_of_force = class({})

--------------------------------------------------------------------------------

function second_wave_wave_of_force:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "max_health_damage" ) 
		
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local info = {
			EffectName = "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_Magnataur.ShockWave.Cast.Anvil", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function second_wave_wave_of_force:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.attack_damage * hTarget:GetMaxHealth() / 100,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )

			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_hit.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true  );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			EmitSoundOn( "Hero_Magnataur.ShockWave.Target", hTarget );
		end

		return false
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------