require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_12_wave_stomp = thisEntity:FindAbilityByName("12_wave_stomp")
	thisEntity:SetContextThink( "12_wave_think_creeps", Think12WaveCreeps , 0.1)
end

function Think12WaveCreeps()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(LiA.AICreepCasts)
		
	if ABILITY_12_wave_stomp:IsFullyCastable() and not thisEntity:IsStunned() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  200, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, 
						  DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
						  FIND_ANY_ORDER, 
						  false)
		--print(#targets)
		if #targets ~= 0 then
			ExecuteOrderFromTable(
			{
		 		UnitIndex = thisEntity:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		AbilityIndex = ABILITY_12_wave_stomp:entindex(), 
		 	})
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end
	return 2
end