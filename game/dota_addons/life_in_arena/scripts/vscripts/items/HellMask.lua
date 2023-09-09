function SpawnHellBeast(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("creep_duration")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220
    
    local unit = CreateUnitByName("hell_beast", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, false)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	--
	unit:SetRenderColor(255,0,0)

	ResolveNPCPositions(unit:GetAbsOrigin(),65)
end