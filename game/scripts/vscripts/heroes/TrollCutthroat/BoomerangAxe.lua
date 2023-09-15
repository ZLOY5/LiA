
--[[Author: Pizzalol
	Date: 07.03.2015.
	Initializes all the needed starting values for the Mystic Snake]]
function Initialize( keys )
	local caster = keys.caster
	local ability = keys.ability

	local ability1 = caster:FindAbilityByName("troll_cuthroat_boomeang_axe")
	local ability2 = caster:FindAbilityByName("troll_cuthroat_boomeang_axe_return")

	ability2:SetLevel(1)

	caster:SwapAbilities("troll_cuthroat_boomeang_axe", "troll_cuthroat_boomeang_axe_return", true, true)

	ability1:SetHidden(true)
	ability2:SetHidden(false)

	caster.boomerang_jumps = 1
	caster.boomerang_table = {}

	local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")

	if whirl ~= nil then
		whirl:SetActivated(true)
	end
end






function BoomerangAxes( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local whirl = caster:FindAbilityByName("troll_cutthroat_enchanted_axes")

	local vulnerability = caster:FindAbilityByName("troll_cutthroat_vulnerability")
	local vulnerability_level = vulnerability:GetLevel()

	local ability1 = caster:FindAbilityByName("troll_cuthroat_boomeang_axe")
	local ability2 = caster:FindAbilityByName("troll_cuthroat_boomeang_axe_return")

	-- Ability variables

	local vision_radius = 0
	local hero_damage = caster:GetAttackDamage() * ability:GetSpecialValueFor("damage_pct") * 0.01
	local damage_final = hero_damage + (caster:GetStrength()*ability:GetSpecialValueFor("str_prc_dmg")*0.01)
	local max_jumps = ability:GetSpecialValueFor("max_targets")
	local time_between_bounces = ability:GetSpecialValueFor("time_between_bounces")
	local initial_speed = ability:GetSpecialValueFor("axe_speed")
	local return_speed = ability:GetLevelSpecialValueFor("return_speed", ability_level) 
	local jump_radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage_pct = ability:GetSpecialValueFor("damage_pct")

	-- Sounds
	local sound_enemy = keys.sound_enemy

	-- Particles
	local boomerang_projectile = keys.boomerang_projectile

	-- Check if the hit target is the caster or an enemy unit
	if target ~= caster then
		-- If its an enemy unit then insert it into the snake table
		-- so that we can keep track that we hit it
		table.insert(caster.boomerang_table, target)

		-- Initialize the damage table
		local damage_table = {}

		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability

		if vulnerability_level <1 then
			damage_table.damage = damage_final
		else
			local vulnerability_chance = vulnerability:GetSpecialValueFor("crit_chance")
			local vulnerability_crit = vulnerability:GetSpecialValueFor("crit_mult") * 0.01
			local random_int = RandomInt(1, 100)

			if random_int <= vulnerability_chance then
				damage_table.damage = damage_final * vulnerability_crit
				vulnerability:ApplyDataDrivenModifier(caster,target,"modifier_troll_cutthroat_vulnerability_debuff",nil)
				SendOverheadEventMessage(target:GetPlayerOwner(), 2, target, damage_table.damage, nil)
			else
				damage_table.damage = damage_final
			end
		end

		
		damage_table.damage_type = ability:GetAbilityDamageType()
		


		-- Play the sound and particle of the spell
		EmitSoundOn(sound_enemy, target)


		-- Deal the damage
		ApplyDamage(damage_table)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_stunned", {duration = stun_duration})

		-- Check if we can do more jumps
		if caster.boomerang_jumps < max_jumps and not caster:HasModifier("modifier_troll_cuthroat_boomeang_axe_return") then


			-- Set up the targeting variables
			local target_team = ability:GetAbilityTargetTeam()
			local target_type = ability:GetAbilityTargetType() 
			local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

			-- Find all the valid units to jump to
			local jump_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, jump_radius, target_team, target_type, target_flags, FIND_CLOSEST, false) 
			local hit_helper -- This variable helps in the case we find only target units that we have already hit before

			-- Check if we found more than 1 target because the original target is included in the search
			if #jump_targets > 1 then
				
				-- Loop through the targets to see if we have a valid one
				for _,v in ipairs(jump_targets) do
					hit_helper = true
					local hit_check = false -- Determines if the target has been hit before or not

					-- Check if the current target has been hit
					for _,k in ipairs(caster.boomerang_table) do
						if v == k then
							hit_check = true
							break
						end
					end

					-- If it wasnt then launch a new snake at it
					if not hit_check then
						local projectile_info = 
						{
							EffectName = boomerang_projectile,
							Ability = ability,
							vSpawnOrigin = target_location,
							Target = v,
							Source = target,
							bHasFrontalCone = false,
							bDodgeable = false,
							iMoveSpeed = initial_speed,
							bReplaceExisting = false,
							bProvidesVision = true,
							iVisionRadius = vision_radius,
							iVisionTeamNumber = caster:GetTeamNumber()
						}
						ProjectileManager:CreateTrackingProjectile(projectile_info)

						-- Increase the jump count and update the helper variable
						caster.boomerang_jumps = caster.boomerang_jumps + 1
						hit_helper = false
						break
					end
				end
			else
				
				-- Send the snake back to the caster if we havent found more targets
				local projectile_info = 
				{
					EffectName = boomerang_projectile,
					Ability = ability,
					vSpawnOrigin = target_location,
					Target = caster,
					Source = target,
					bHasFrontalCone = false,
					bDodgeable = false,
					iMoveSpeed = return_speed,
					bReplaceExisting = false,
					bProvidesVision = true,
					iVisionRadius = vision_radius,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				ProjectileManager:CreateTrackingProjectile(projectile_info)

			end
			-- Check the helper variable to determine if we have to send the snake back to the caster
			-- Happens only in the case where we find only targets that we hit before but havent reached
			-- the jump limit
			if hit_helper then
				local projectile_info = 
				{
					EffectName = boomerang_projectile,
					Ability = ability,
					vSpawnOrigin = target_location,
					Target = caster,
					Source = target,
					bHasFrontalCone = false,
					iMoveSpeed = return_speed,
					bReplaceExisting = false,
					bDodgeable = false,
					bProvidesVision = true,
					iVisionRadius = vision_radius,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				ProjectileManager:CreateTrackingProjectile(projectile_info)
			end
		else
			-- Send the snake back to the caster because we hit the jump limit
			local projectile_info = 
			{
				EffectName = boomerang_projectile,
				Ability = ability,
				vSpawnOrigin = target_location,
				Target = caster,
				Source = target,
				bHasFrontalCone = false,
				bDodgeable = false,
				iMoveSpeed = return_speed,
				bReplaceExisting = false,
				bProvidesVision = true,
				iVisionRadius = vision_radius,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
		end
	else
		caster:RemoveModifierByName("modifier_troll_cuthroat_boomeang_axe_disarm")
		caster:RemoveModifierByName("modifier_troll_cuthroat_boomeang_axe_return")
		caster:SwapAbilities("troll_cuthroat_boomeang_axe_return", "troll_cuthroat_boomeang_axe", false, true)
		ability2:SetHidden(true)
		ability1:SetHidden(false)
		if whirl ~= nil and not caster:HasModifier("modifier_troll_cutthroat_battle_trance") and not caster:HasModifier("modifier_troll_cuthroat_boomeang_axe_disarm") then
			whirl:SetActivated(false)
		end	

	end
end



