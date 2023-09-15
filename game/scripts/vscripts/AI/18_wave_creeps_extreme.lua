if IsClient() then return end
require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_18_wave_silence = thisEntity:FindAbilityByName("18_wave_silence_extreme")
	thisEntity:SetContextThink( "AIThink", AIThink , 0.1)
end

function AIThink()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(LiA.AICreepCasts)
		
	if thisEntity:IsStunned() then 
		return 2 
	end

	if ABILITY_18_wave_silence:IsFullyCastable() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
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
		for k,unit in pairs(targets) do 
			if unit:HasModifier("modifier_18_wave_silence") then 
				table.remove(targets,k)
			end 
		end 
		
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_18_wave_silence, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end
	return 2
end