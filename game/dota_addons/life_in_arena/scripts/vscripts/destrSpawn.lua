require('timers')

function Spawn(entityKeyValues)
	thisEntity.destructable = 1
	thisEntity:FindAbilityByName("barrel_no_health_bar"):SetLevel(1)
	if thisEntity:GetUnitName() == "barricades" or thisEntity:GetUnitName() == "arena_rock" then
		thisEntity:SetHullRadius(40)
	else 
		thisEntity:SetHullRadius(24)
	end
	if thisEntity:GetUnitName() == "tnt_barrel" then
        thisEntity:FindAbilityByName("barrel_explosion"):SetLevel(1)
    end
	thisEntity:SetTeam(DOTA_TEAM_GOODGUYS)
	Timers:CreateTimer(0.01,function()
		thisEntity:RemoveModifierByName("modifier_invulnerable")
	end)
	--print("barrelspawned")
end