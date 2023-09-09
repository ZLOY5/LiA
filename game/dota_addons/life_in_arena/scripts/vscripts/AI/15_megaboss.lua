if IsClient() then return end
require('survival/AIcreeps')
require('timers')

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_15_megaboss_illusions = thisEntity:FindAbilityByName("15_megaboss_illusions")
	ABILITY_15_megaboss_astral = thisEntity:FindAbilityByName("15_megaboss_astral")
	ABILITY_15_megaboss_silence = thisEntity:FindAbilityByName("15_megaboss_silence")
	thisEntity:SetContextThink( "15_megaboss_think", Think15Wave , 2)

	Timers:CreateTimer(0.1,function()
		
	
	thisEntity:AddNewModifier(thisEntity,nil,"modifier_megaboss_three_stats",nil)
	

	end)
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
		return 2
	end

	if thisEntity:IsStunned() then 
		return 2 
	end

	if ABILITY_15_megaboss_silence:IsFullyCastable() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  1000, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_15_megaboss_silence, -1)
		end

	elseif ABILITY_15_megaboss_astral:IsFullyCastable() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  800, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		for k,target in pairs(targets) do 
			if target:HasModifier("modifier_decrepify_hero") or target:HasModifier("mod_15_megaboss_silence") then
				table.remove(targets,k)
			end
		end
		
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_15_megaboss_astral, -1)
		end
	
	end
	
	return 2
end
