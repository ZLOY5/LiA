require('LiA_AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
	ABILILTY_12_wave_stomp = thisEntity:FindAbilityByName("12_wave_stomp")

	thisEntity:SetContextThink( "12_wave_think", Think12Wave , 1)
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
		
	if ABILILTY_12_wave_stomp:IsFullyCastable() and LiA.AICreepCasts < LiA.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  250, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		--print(#targets)
		if #targets ~= 0 then
			thisEntity:CastAbilityNoTarget(ABILILTY_12_wave_stomp, -1)
			LiA.AICreepCasts = LiA.AICreepCasts + 1
		end
	end
	return 1
end