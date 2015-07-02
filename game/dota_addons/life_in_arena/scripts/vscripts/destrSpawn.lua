require('timers')

function Spawn(entityKeyValues)
	thisEntity:FindAbilityByName("barrel_no_health_bar"):SetLevel(1)
	thisEntity:SetHullRadius(26)
	if thisEntity:GetUnitName() == "tnt_barrel" then
        thisEntity:FindAbilityByName("barrel_explosion"):SetLevel(1)
    end
	thisEntity:SetTeam(DOTA_TEAM_GOODGUYS)
	Timers:CreateTimer(0.01,function()
		thisEntity:RemoveModifierByName("modifier_invulnerable")
	end)
	--print("barrelspawned")
end