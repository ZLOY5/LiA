require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_6_wave_cripple = thisEntity:FindAbilityByName("6_wave_cripple")

	thisEntity:SetContextThink( "6_wave_cripple", Think6Wave , 0.1)
end

function Think6Wave()
	if not thisEntity:IsAlive() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(Survival.AICreepCasts)
		
	if ABILITY_6_wave_cripple:IsFullyCastable() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  700, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)
		if #targets ~= 0 then
			local targetTo = nil
			for i=1,#targets do
				if not targets[i]:HasModifier("modifier_6_wave_cripple") then
					targetTo = targets[i]
				end
			end
			if targetTo ~= nil then
				thisEntity:CastAbilityOnTarget(targetTo, ABILITY_6_wave_cripple, -1)
				Survival.AICreepCasts = Survival.AICreepCasts + 1
			end
		end
	end	
	
	return 2
end