require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_12_wave_bloodlust = thisEntity:FindAbilityByName("12_wave_bloodlust")
	ABILITY_12_wave_roots = thisEntity:FindAbilityByName("12_wave_roots")
	thisEntity:SetContextThink( "12_wave_think", Think12Wave , 0.1)
end

function Think12Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
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
	else
		if ABILITY_12_wave_roots:IsFullyCastable() and not thisEntity:IsStunned() and Survival.AICreepCasts < Survival.AIMaxCreepCasts then
			local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
							  thisEntity:GetOrigin(), 
							  nil, 
							  600, 
							  DOTA_UNIT_TARGET_TEAM_ENEMY, 
							  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
							  DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 
							  FIND_ANY_ORDER, 
							  false)
			for k,unit in pairs(targets) do 
				if unit:HasModifier("modifier_entangling_roots") or unit:IsStunned() then 
					table.remove(targets,k)
				end 
			end 
			
			if #targets ~= 0 then
				thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_12_wave_roots, -1)
				Survival.AICreepCasts = Survival.AICreepCasts + 1
			end
		
		end
	
	end	
	
	
	return 2
end