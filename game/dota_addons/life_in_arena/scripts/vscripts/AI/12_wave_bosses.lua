require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_12_wave_bloodlust = thisEntity:FindAbilityByName("12_wave_bloodlust")

	thisEntity:SetContextThink( "12_wave_think", Think12Wave , 0.1)
end

function Think12Wave()
	if not thisEntity:IsAlive() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(LiA.AICreepCasts)
		
	if ABILITY_12_wave_bloodlust:IsFullyCastable() and not thisEntity:IsStunned() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		if thisEntity:GetHealthPercent() >= 25 then
			thisEntity:CastAbilityNoTarget(ABILITY_12_wave_bloodlust, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end	
	
	return 2
end