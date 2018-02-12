vowen_from_blood_steal_blood = class({})

function vowen_from_blood_steal_blood:GetManaCost( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function vowen_from_blood_steal_blood:OnSpellStart()
	self.jumps = 0 -- number of hit units
	self.targets_table = {} -- table of hit units

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
	EmitSoundOn( "Hero_TrollWarlord.PreAttack", self:GetCaster() )
end


function vowen_from_blood_steal_blood:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	if hTarget ~= nil then
		local target_location = hTarget:GetAbsOrigin()
		local hit_helper -- variable used to define if there are valid targets left

		EmitSoundOn( "Hero_TrollWarlord.ProjectileImpact", hTarget )

		-- enter a unit into the table and increment the variable on hot
		table.insert(self.targets_table, hTarget) 
		self.jumps = self.jumps + 1
		print(self.jumps)

		ApplyDamage({victim = hTarget, attacker = self:GetCaster(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage})
		caster:Heal(self.heal_per_target, caster)



		if self.jumps < self.bounces then -- search for anorher target if hit count hasn't reached the target limit
			
			-- search for units around the last target
			local possible_targets = FindUnitsInRadius(caster:GetTeam(), 
								target_location, 
								nil, self.bounce_range, 
								DOTA_UNIT_TARGET_TEAM_ENEMY, 
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

			

			if #possible_targets > 1 then -- if the last target hit is not the only one in radius the move on 
				for _,v in ipairs(possible_targets) do
					hit_helper = false
					local hit_check = false -- variable to show that the compared units are the same

					-- if the compared units are the same, check the next target
					for _,k in ipairs(self.targets_table) do
						if k == v then 
							hit_check = true
							break
						end
					end	

					-- if the target hasn't been hit, send the axe to it
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
						hit_helper = true -- we've found a valid target
						break
					end
					
				end

			end

		end
	end

	return true
end
