require('LiA_AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
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

	--AICreepsAttackOneUnit({unit = thisEntity})
	--print(LiA.AICreepCasts)
		
	if ABILITY_12_wave_bloodlust:IsFullyCastable() and LiA.AICreepCasts < LiA.AIMaxCreepCasts then
		if thisEntity:GetHealthPercent() >= 25 then
			thisEntity:CastAbilityNoTarget(ABILITY_12_wave_bloodlust, -1)
			LiA.AICreepCasts = LiA.AICreepCasts + 1
		end
	end	
	
	return 1
end