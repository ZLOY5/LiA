require('timers')

function Spawn(entityKeyValues)
	Timers:CreateTimer(0.01,function()
		thisEntity:RemoveModifierByName("modifier_invulnerable")
	end)
	thisEntity:FindAbilityByName("healing_ward_ability"):SetLevel(1)
	ResolveNPCPositions(thisEntity:GetAbsOrigin(),65)
end