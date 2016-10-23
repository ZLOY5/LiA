function Create(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local durat = keys.durat
	local count = keys.count
	--
	local PID = caster:GetPlayerOwnerID()
	
    --local playerID =player:GetPlayerID()
	--local target = keys.target --enemy
	--local target = keys.target_entities[1] --enemy
	--local targets = keys.target_entities
	local lvl = ability:GetLevel()-1
	--
	--
	local unitname
	if caster:HasItemInInventory("item_lia_spherical_staff") then
		if lvl == 0 then
			unitname = "necromancer_skeleton2"
		end
		if lvl == 1 then
			unitname = "necromancer_skeleton3"
		end
		if lvl == 2 then
			unitname = "necromancer_skeleton4"
		end
	else
		if lvl == 0 then
			unitname = "necromancer_skeleton1"
		end
		if lvl == 1 then
			unitname = "necromancer_skeleton2"
		end
		if lvl == 2 then
			unitname = "necromancer_skeleton3"
		end
	end
	
	local front_position = caster:GetAbsOrigin() + caster:GetForwardVector() * 200
	
	--
	for i=1,count do
		local cre = CreateUnitByName(unitname, front_position, false, caster, caster, caster:GetTeam())
		cre:SetControllableByPlayer(PID, false)
		--
		cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
		cre:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(cre:GetAbsOrigin(),65)
	end
	
end