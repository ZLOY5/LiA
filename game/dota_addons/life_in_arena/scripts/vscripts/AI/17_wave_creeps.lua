require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_17_wave_purge = thisEntity:FindAbilityByName("17_wave_purge")
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
		
	if ABILITY_17_wave_purge:IsFullyCastable() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
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
			if unit:HasModifier("modifier_purge_slow") then 
				table.remove(targets,k)
			end 
		end 
		
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_17_wave_purge, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end
	return 2
end