require('survival/AIcreeps')

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_15_megaboss_illusions = thisEntity:FindAbilityByName("15_megaboss_illusions")
	ABILITY_15_megaboss_astral = thisEntity:FindAbilityByName("15_megaboss_astral")
	thisEntity:SetContextThink( "15_megaboss_think", Think15Wave , 2)
end

function Think15Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	if ABILITY_15_megaboss_illusions:IsFullyCastable() and thisEntity:GetHealthPercent() < 80 then
		thisEntity:CastAbilityNoTarget(ABILITY_15_megaboss_illusions, -1)
	else
		if ABILITY_15_megaboss_astral:IsFullyCastable() then
			local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
							  thisEntity:GetOrigin(), 
							  nil, 
							  800, 
							  DOTA_UNIT_TARGET_TEAM_ENEMY, 
							  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
							  DOTA_UNIT_TARGET_FLAG_NONE, 
							  FIND_ANY_ORDER, 
							  false)
			if #targets ~= 0 then
				local targetTo = nil
				for i=1,#targets do
					if not targets[i]:HasModifier("modifier_decrepify_hero") and not targets[i]:HasModifier("mod_15_megaboss_silence") then
						targetTo = targets[i]
					end
				end
				if targetTo ~= nil then
					thisEntity:CastAbilityOnTarget(targetTo, ABILITY_15_megaboss_astral, -1)
				end
			end
		end
	end
	
	return 2
end