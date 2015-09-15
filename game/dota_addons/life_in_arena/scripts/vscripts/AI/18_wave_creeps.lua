require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(32) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_18_wave_silence = thisEntity:FindAbilityByName("18_wave_silence")
	thisEntity:SetContextThink( "AIThink", AIThink , 0.1)
end

function AIThink()
	if not thisEntity:IsAlive() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(LiA.AICreepCasts)
		
	if ABILITY_18_wave_silence:IsFullyCastable() and not thisEntity:IsStunned() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  700, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 
						  FIND_ANY_ORDER, 
						  false)
		--print(#targets)
		if #targets ~= 0 then
			local targetTo = nil
			for i=1,#targets do
				if not targets[i]:HasModifier("18_wave_silence") then
					targetTo = targets[i]
				end
			end
			if targetTo ~= nil then
				thisEntity:CastAbilityOnTarget(targetTo, ABILITY_18_wave_silence, -1)
				Survival.AICreepCasts = Survival.AICreepCasts + 1
			end
		end
		
		--if #targets ~= 0 then
		--	thisEntity:CastAbilityNoTarget(ABILITY_18_wave_silence, -1)
		--	Survival.AICreepCasts = Survival.AICreepCasts + 1
		--end
	end
	return 2
end