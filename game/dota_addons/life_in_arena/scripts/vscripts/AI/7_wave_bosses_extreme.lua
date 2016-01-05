require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_7_wave_howl_of_terror = thisEntity:FindAbilityByName("7_wave_howl_of_terror_extreme")
	thisEntity:SetContextThink( "7_wave_think", Think7Wave , 0.1)
end

function Think7Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	if thisEntity:IsStunned() then 
		return 2 
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(Survival.AICreepCasts)
		
	if ABILITY_7_wave_howl_of_terror:IsFullyCastable() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  800, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		--print(#targets)
		if #targets ~= 0 then
			thisEntity:CastAbilityNoTarget(ABILITY_7_wave_howl_of_terror, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end
	return 2
end