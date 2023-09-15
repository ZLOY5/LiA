function SpawnSkeletons(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("duration")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220
    
    local unit = CreateUnitByName("book_of_the_dead_skeleton_melee", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    
    unit = CreateUnitByName("book_of_the_dead_skeleton_melee", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
	unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    
	local front_position = origin + fv * 250

    unit = CreateUnitByName("book_of_the_dead_skeleton_melee_ranged", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    
    unit = CreateUnitByName("book_of_the_dead_skeleton_melee_ranged", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})

    ResolveNPCPositions(unit:GetAbsOrigin(),65)
end