require('timers')

function Spawn(entityKeyValues)
	thisEntity.destructable = 1
	thisEntity:FindAbilityByName("barrel_no_health_bar"):SetLevel(1)
	
	local unitName = thisEntity:GetUnitName()



	if unitName == "barricades" or unitName == "arena_rock" then
		thisEntity:SetHullRadius(50)
	end

	if unitName == "barricades_big" then
		thisEntity:SetHullRadius(55)
	end

	if unitName == "barricades_small" then
		thisEntity:SetHullRadius(45)
	end

	if unitName == "big_barrel" then
		thisEntity:SetHullRadius(24)
	end

	if unitName == "small_barrel" then
		thisEntity:SetHullRadius(24)
	end
	
	if unitName == "npc_dota_creature_barrel" then
		thisEntity:SetHullRadius(24)
	end

	if unitName == "small_barrel_side" then
		thisEntity:SetHullRadius(50)
	end

	if thisEntity:GetUnitName() == "tnt_barrel" then
        thisEntity:FindAbilityByName("barrel_explosion"):SetLevel(1)
    end
	
	thisEntity:SetTeam(DOTA_TEAM_GOODGUYS)
	
	Timers:CreateTimer(0.01,function()
		thisEntity:RemoveModifierByName("modifier_invulnerable")

		--print(unitName,thisEntity:GetHullRadius())
	end)
	--print("barrelspawned")
end