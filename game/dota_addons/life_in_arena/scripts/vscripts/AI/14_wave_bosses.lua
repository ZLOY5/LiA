require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_14_wave_storm_bolt = thisEntity:FindAbilityByName("14_wave_storm_bolt")
	thisEntity:SetContextThink( "14_wave_think", Think14Wave , 0.1)
end

function Think14Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(Survival.AICreepCasts)
		
	if ABILITY_14_wave_storm_bolt:IsFullyCastable() and not thisEntity:IsStunned() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  900, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_14_wave_storm_bolt, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end	
	
	return 2
end