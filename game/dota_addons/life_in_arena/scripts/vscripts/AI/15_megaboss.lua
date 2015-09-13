require('survival/AIcreeps')

function Spawn(entityKeyValues)
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_15_megaboss_illusions = thisEntity:FindAbilityByName("15_megaboss_illusions")
	thisEntity:SetContextThink( "15_megaboss_think", Think15Wave , 2)
end

function Think15Wave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	if ABILITY_15_megaboss_illusions:IsFullyCastable() and thisEntity:GetHealthPercent() < 80 then
		thisEntity:CastAbilityNoTarget(ABILITY_15_megaboss_illusions, -1)
	end	
	
	return 2
end