function SpawnEgg(event)
	--local point = event.target_points[1]
	
	local dummy = CreateUnitByName("npc_dummy_blank", event.caster:GetAbsOrigin(), true, event.caster, nil, event.caster:GetTeam())
	
	local egg = CreateUnitByName("phoenix_egg_bm", dummy:GetAbsOrigin(), false, event.caster, nil, event.caster:GetTeam())
	
	dummy:RemoveSelf()
end