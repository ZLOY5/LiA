troll_cutthroat_boomeang_axe = class({})
LinkLuaModifier("modifier_troll_cutthroat_boomeang_axe_damage","heroes/TrollCutthroat/modifier_troll_cutthroat_boomeang_axe_damage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_cutthroat_boomeang_axe_disarm","heroes/TrollCutthroat/modifier_troll_cutthroat_boomeang_axe_disarm.lua",LUA_MODIFIER_MOTION_NONE)

function troll_cutthroat_boomeang_axe:OnSpellStart()
	self.boomerang_jumps = 0 -- number of hit units
	self.boomerang_table = {} -- table of hit units

	self.axe_speed = self:GetSpecialValueFor( "axe_speed" )
	self.max_targets = self:GetSpecialValueFor( "max_targets" )
	self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
	self.radius = self:GetSpecialValueFor( "radius" )
	self.return_speed = self:GetSpecialValueFor( "return_speed" )

	-- swap the main ability with the ability used to return the axe back
	local caster = self:GetCaster()
	local ability1 = caster:FindAbilityByName("troll_cutthroat_boomeang_axe")
	local ability2 = caster:FindAbilityByName("troll_cutthroat_boomeang_axe_return")

	ability2:SetLevel(1)
	caster:SwapAbilities("troll_cutthroat_boomeang_axe", "troll_cutthroat_boomeang_axe_return", true, true)
	ability1:SetHidden(true)
	ability2:SetHidden(false)
	if not caster:HasModifier("modifier_troll_cutthroat_battle_trance") then
		caster:AddNewModifier(caster, self, "modifier_troll_cutthroat_boomeang_axe_disarm", nil)
	end

	-- activate Enchanted Axes ability
	local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")

	if whirl then
		whirl:SetActivated(true)
	end

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


function troll_cutthroat_boomeang_axe:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	if hTarget ~= caster then
		if hTarget ~= nil then
			local target_location = hTarget:GetAbsOrigin()
			local hit_helper -- variable used to define if there are valid targets left

			EmitSoundOn( "Hero_TrollWarlord.ProjectileImpact", hTarget )

			-- enter a unit into the table and increment the variable on hot
			table.insert(self.boomerang_table, hTarget) 
			self.boomerang_jumps = self.boomerang_jumps + 1

			-- axe performs a ranged attack on the target with reduced damage
	--		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
			caster:AddNewModifier(caster, self, "modifier_troll_cutthroat_boomeang_axe_damage", nil)
			caster:PerformAttack( hTarget, true, true, true, true, false, false, true )
			caster:RemoveModifierByName("modifier_troll_cutthroat_boomeang_axe_damage")
	--		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

			-- return axe back to the hero if he used Return Axe ability
			if caster:HasModifier("modifier_troll_cutthroat_boomeang_axe_return") then
				self:SendAxeToCaster(hTarget)
				return
			end

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
					if hit_helper == false then -- if there are no valid targets, then axe goes back to the hero
						self:SendAxeToCaster(hTarget)
					end
				else
					self:SendAxeToCaster(hTarget) -- if the last target was the only, then axe goes back to the hero
				end
			else
				self:SendAxeToCaster(hTarget) -- if we've reached the hit limit, then axe goes back to the hero
			end
		end
	else
		-- swap the abilities back and deactivate Enchanted Axes
		local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")
		local ability1 = caster:FindAbilityByName("troll_cutthroat_boomeang_axe")
		local ability2 = caster:FindAbilityByName("troll_cutthroat_boomeang_axe_return")
		if caster:HasModifier("modifier_troll_cutthroat_boomeang_axe_disarm") then
			caster:RemoveModifierByName("modifier_troll_cutthroat_boomeang_axe_disarm")
		end
		if caster:HasModifier("modifier_troll_cutthroat_boomeang_axe_return") then
			caster:RemoveModifierByName("modifier_troll_cutthroat_boomeang_axe_return")
		end
		caster:SwapAbilities("troll_cutthroat_boomeang_axe_return", "troll_cutthroat_boomeang_axe", false, true)
		ability2:SetHidden(true)
		ability1:SetHidden(false)
		if whirl and not caster:HasModifier("modifier_troll_cutthroat_battle_trance") then
			whirl:SetActivated(false)
		end	
	end

	return true
end

function troll_cutthroat_boomeang_axe:SendAxeToCaster(hSource)
	local info = {
			EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
			Ability = self,
			iMoveSpeed = self.return_speed,
			Source = hSource,
			Target = self:GetCaster(),
			bDodgeable = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

	ProjectileManager:CreateTrackingProjectile( info )
end