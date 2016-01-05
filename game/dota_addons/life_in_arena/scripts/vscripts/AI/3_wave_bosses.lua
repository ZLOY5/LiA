require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_3_wave_rejuvenation = thisEntity:FindAbilityByName("3_wave_rejuvenation")
	thisEntity:SetContextThink( "3_wave_think", Think3Wave , 0.1)
end

function Think3Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(Survival.AICreepCasts)

	if thisEntity:IsStunned() then 
		return 2 
	end
		
	if ABILITY_3_wave_rejuvenation:IsFullyCastable() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		if thisEntity:GetHealthPercent() <= 50 then
			thisEntity:CastAbilityOnTarget(thisEntity, ABILITY_3_wave_rejuvenation, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end	
	
	return 2
end