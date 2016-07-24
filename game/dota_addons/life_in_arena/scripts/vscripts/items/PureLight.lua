function SpawnTotem( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local totem_duration =  ability:GetLevelSpecialValueFor( "totem_duration" , ability:GetLevel() - 1  )
	local building_name = "pure_light_totem"
	local sizeBuild = 24

	local dummy = CreateUnitByName("npc_dummy_blank", point, false, caster, nil, caster:GetTeam())
	dummy:SetHullRadius(sizeBuild) --160
	FindClearSpaceForUnit(dummy, point, true)
	
	-- Create the building, set to time out after a duration
	caster.pure_light_totem = CreateUnitByName(building_name, dummy:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	caster.pure_light_totem:SetHullRadius(sizeBuild)
	Timers:CreateTimer(0.01,
	function()
		ResolveNPCPositions(point,sizeBuild*2)
		FindClearSpaceForUnit(caster.pure_light_totem, point, true)
	end)
	caster.pure_light_totem:SetControllableByPlayer(caster:GetPlayerID(), true)
	

	dummy:RemoveSelf()

	caster.pure_light_totem:AddNewModifier(caster, nil, "modifier_kill", {duration = totem_duration})
	caster.pure_light_totem:RemoveModifierByName("modifier_invulnerable")
	caster.pure_light_totem.no_corpse = true
	--Timers:CreateTimer(0.03, function() caster.pocket_factory:SetAbsOrigin(point) end)

	

end