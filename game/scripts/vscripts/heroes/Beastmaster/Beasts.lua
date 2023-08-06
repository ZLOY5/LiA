function SummonBeasts(event)
	local point = event.target_points[1]

	local unit_name = {"white_wolf_bm","jungle_stalker_bm","phoenix_bm","bear_bm"}
	local ability = event.ability
	local count = ability:GetLevelSpecialValueFor("unit_count" , ability:GetLevel() - 1  )
	local level = ability:GetLevel()
	for i=1,count do
		local num = RandomInt(1, level+1)
		bm_beast = CreateUnitByName(unit_name[num], point, true, event.caster, event.caster, event.caster:GetTeam())
		bm_beast:SetControllableByPlayer(event.caster:GetPlayerID(), true)
		ResolveNPCPositions(bm_beast:GetAbsOrigin(),100)
	end

end