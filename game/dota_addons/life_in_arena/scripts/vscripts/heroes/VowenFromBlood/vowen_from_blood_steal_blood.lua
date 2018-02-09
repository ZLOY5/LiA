vowen_from_blood_steal_blood = class({})

function vowen_from_blood_steal_blood:OnSpellStart()
	self.jumps = 0 -- number of hit units
	self.targets_table = {} -- table of hit units

	self.axe_speed = self:GetSpecialValueFor( "axe_speed" )
	self.max_targets = self:GetSpecialValueFor( "max_targets" )
	self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
	self.radius = self:GetSpecialValueFor( "radius" )
	self.return_speed = self:GetSpecialValueFor( "return_speed" )

	-- send the projectile to the target
	local info = {
			EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
			Ability = self,
			iMoveSpeed = self.axe_speed,
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
		table.insert(self.boomerang_table, hTarget) 
		self.boomerang_jumps = self.boomerang_jumps + 1


		if self.boomerang_jumps < self.max_targets then -- search for anorher target if hit count hasn't reached the target limit
			
			-- search for units around the last target
			local jump_targets = FindUnitsInRadius(caster:GetTeam(), 
								target_location, 
								nil, self.radius, 
								DOTA_UNIT_TARGET_TEAM_ENEMY, 
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

			

			if #jump_targets > 1 then -- if the last target hit is not the only one in radius the move on 
				for _,v in ipairs(jump_targets) do
					hit_helper = false
					local hit_check = false -- variable to show that the compared units are the same

					-- if the compared units are the same, check the next target
					for _,k in ipairs(self.boomerang_table) do
						if k == v then 
							hit_check = true
							break
						end
					end	

					-- if the target hasn't been hit, send the axe to it
					if not hit_check then
						local info = {
								EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
								Ability = self,
								iMoveSpeed = self.axe_speed,
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
