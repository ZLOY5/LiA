function SpawnHellBeast(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("creep_duration")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220
    
    unit = CreateUnitByName("hell_beast", front_position, true, caster, nil, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
end