--[[
	Author: Noya
	Date: 17.01.2015.
	Bounces a chain lightning
]]
function BoomerangAxes( event )

	local hero = event.caster
	local target = event.target
	local ability = event.ability

	
	local damage = ability:GetSpecialValueFor("init_damage") + (hero:GetStrength()*ability:GetSpecialValueFor("str_prc_dmg")*0.01)
	local bounces = ability:GetSpecialValueFor("max_targets")
	local bounce_range = ability:GetSpecialValueFor("bounce_range")
	local time_between_bounces = ability:GetSpecialValueFor("time_between_bounces")
	local speed = ability:GetSpecialValueFor("axe_speed")


	if ability.bounces_left == nil then
		ability.bounces_left = bounces
		local targetsStruck = {}
		target.struckByChain = true
		table.insert(targetsStruck,target)
	else
		ability.bounces_left = ability.bounces_left - 1
	end

	EmitSoundOn("Hero_TrollWarlord.ProjectileImpact", target)	

	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })
	--PopupDamage(target,math.floor(damage))

	-- Every target struck by the chain is added to a list of targets struck, And set a boolean inside its index to be sure we don't hit it twice.
	



	

	
			-- unit selection and counting
		local	units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetOrigin(), target, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, 
						DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

			

			-- Track the possible targets to bounce from the units in radius
			local possibleTargetsBounce = {}
			for _,v in pairs(units) do
				if not v.struckByChain then
					table.insert(possibleTargetsBounce,v)
				end
			end

			-- Select nearest unit
			local newTarget 
			local distance = 9999999
			local newTargetVec
			for _,v in pairs(possibleTargetsBounce) do
				newTargetVec = v:GetAbsOrigin()
				--print(v,DistanceBetweenVectors(targetVec,newTargetVec)) 
				if v ~= target then
					if DistanceBetweenPoints(targetVec,newTargetVec) < distance then
						newTarget = v
						distance = DistanceBetweenPoints(targetVec,newTargetVec)
					end
				end
			end

			

			target = newTarget

			if target then
				target.struckByChain = true
				table.insert(targetsStruck,target)		
			else
				-- There's no more targets left to bounce, clear the struck table and end
				for _,v in pairs(targetsStruck) do
				    v.struckByChain = false
				    v = nil
				end
			    --print("End Chain, no more targets")
				return	
			end

			local info = {
				Target = target,
				Source = dummy,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}
			ProjectileManager:CreateTrackingProjectile( info )
			

			

			-- damage and decay
			
			ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })
			--PopupDamage(target,math.floor(damage))
			--print("Bounce "..bounces.." Hit Unit "..target:GetEntityIndex().. " for "..damage.." damage")

			-- play the sound
			EmitSoundOn("Hero_TrollWarlord.ProjectileImpact",target)

			-- make the particle shoot to the target

	
			-- decrement remaining spell bounces
			

			-- fire the timer again if spell bounces remain
			if bounces_left > 0 then
				return time_between_bounces
			else
				for _,v in pairs(targetsStruck) do
				   	v.struckByChain = false
				   	v = nil
				end
				--print("End Chain, no more bounces")
			end

end