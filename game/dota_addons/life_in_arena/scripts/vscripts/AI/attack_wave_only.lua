if IsClient() then return end
require('survival/AIcreeps')

function Spawn(entityKeyValues)
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	thisEntity:SetContextThink( "attack_wave_only", ThinkAllWave , 0.1)
end

function ThinkAllWave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	if not thisEntity:HasModifier("modifier_beastmaster_dominate") then
		AICreepsAttackOneUnit({unit = thisEntity})
	end
	
	return 2
end