require('survival/AIcreeps')

function Spawn(entityKeyValues)
	thisEntity:SetContextThink( "attack_wave_only", ThinkAllWave , 0.1)
end

function ThinkAllWave()
	if not thisEntity:IsAlive() then
		return nil 
	end
	if GameRules:IsGamePaused() then
		return 1
	end
	AICreepsAttackOneUnit({unit = thisEntity})
	return 1
end