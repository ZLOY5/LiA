function SpawnWard(event)
	--local point = event.target_points[1]
	
	local dummy = CreateUnitByName("npc_dummy_blank", event.ability:GetCursorPosition(), true, event.caster, nil, event.caster:GetTeam())
	
	local ward = CreateUnitByName("item_lia_healing_ward_unit", dummy:GetAbsOrigin(), false, event.caster, nil, event.caster:GetTeam())
	ward:AddNewModifier(ward, nil, "modifier_kill", {duration = 30})
	ward:SetHullRadius(0)
	dummy:RemoveSelf()
end