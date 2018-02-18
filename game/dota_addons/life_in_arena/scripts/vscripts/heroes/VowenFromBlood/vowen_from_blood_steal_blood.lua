vowen_from_blood_steal_blood = class({})

function vowen_from_blood_steal_blood:GetManaCost( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function vowen_from_blood_steal_blood:OnSpellStart()
	self.jumps = 0 
	self.targets_table = {} 

	self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	self.bounce_range = self:GetSpecialValueFor( "bounce_range" )
	self.heal_per_target = self:GetSpecialValueFor( "heal_per_target" )

	if self:GetCaster():HasScepter() then
		self.damage = self:GetSpecialValueFor( "damage_scepter" )
		self.bounces = self:GetSpecialValueFor( "bounces_scepter" )
	else
		self.damage = self:GetSpecialValueFor( "damage" )
		self.bounces = self:GetSpecialValueFor( "bounces" )
	end

	local info = {
			EffectName = "particles/custom/bloodwoven/bloodwoven_bloodworm_projectile.vpcf",
			Ability = self,
			iMoveSpeed = self.projectile_speed,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			bDodgeable = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Medusa.MysticSnake.Cast", self:GetCaster() )
end


function vowen_from_blood_steal_blood:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	if hTarget ~= nil then
		local target_location = hTarget:GetAbsOrigin()
		local hit_helper

		EmitSoundOn( "Hero_Medusa.MysticSnake.Target", hTarget )

		table.insert(self.targets_table, hTarget) 
		self.jumps = self.jumps + 1

		ApplyDamage({victim = hTarget, attacker = self:GetCaster(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage})
		caster:Heal(self.heal_per_target, caster)
		local nFXIndex = ParticleManager:CreateParticle( "particles/custom/bloodwoven/bloodwoven_bloodworm_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin() )

		if self.jumps < self.bounces then 

			local possible_targets = FindUnitsInRadius(caster:GetTeam(), 
								target_location, 
								nil, self.bounce_range, 
								DOTA_UNIT_TARGET_TEAM_ENEMY, 
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

			

			if #possible_targets > 1 then
				for _,v in ipairs(possible_targets) do
					hit_helper = false
					local hit_check = false

					for _,k in ipairs(self.targets_table) do
						if k == v then 
							hit_check = true
							break
						end
					end	

					if not hit_check then
						local info = {
								EffectName = "particles/custom/bloodwoven/bloodwoven_bloodworm_projectile.vpcf",
								Ability = self,
								iMoveSpeed = self.projectile_speed,
								Source = hTarget,
								Target = v,
								bDodgeable = false,
								iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
							}

						ProjectileManager:CreateTrackingProjectile( info )
						hit_helper = true 
						break
					end
					
				end

			end

		end
	end

	return true
end
