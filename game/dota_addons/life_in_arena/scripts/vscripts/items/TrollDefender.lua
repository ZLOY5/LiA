function SpawnTroll(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("duration")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220
    
    unit = CreateUnitByName("troll_defender", front_position, true, caster, nil, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
end