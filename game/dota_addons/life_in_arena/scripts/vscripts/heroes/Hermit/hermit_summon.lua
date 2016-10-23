function summonCreate(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	
	local num = ability:GetSpecialValueFor( "unit_count" )
	local durat = ability:GetSpecialValueFor( "duration" )
	
	if not caster.tUnits then
		caster.tUnits = {}
	else
		for i=1, #caster.tUnits do
			if not caster.tUnits[i]:IsNull() then
				caster.tUnits[i]:ForceKill(false)
			end
		end
		caster.tUnits = {}
	end

	local lvl = ability:GetLevel()-1
	local unitname
	
	local flag = false
	if caster:HasItemInInventory("item_lia_spherical_staff") then
		if lvl == 0 then
			unitname = "npc_water_elemental_2"
		end
		if lvl == 1 then
			unitname = "npc_water_elemental_3"
		end
		if lvl == 2 then
			flag = true
			unitname = "npc_water_elemental_4"
		end
	else
		if lvl == 0 then
			unitname = "npc_water_elemental_1"
		end
		if lvl == 1 then
			unitname = "npc_water_elemental_2"
		end
		if lvl == 2 then
			unitname = "npc_water_elemental_3"
		end
	end
	
	local front_position = caster:GetAbsOrigin() + caster:GetForwardVector() * 200
   
	for i=1, num do
		local cre = CreateUnitByName(unitname, front_position, true, caster, caster, caster:GetTeam())
		cre:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
			
		--
		cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
		
		--if caster:HasModifier("modifier_decrepify_units_by_hero") then
		--	caster:FindAbilityByName("hermit_astral"):ApplyDataDrivenModifier( caster, cre, 'modifier_decrepify_units_by_hero', {} )
		--end

		if flag then
			cre:SetRenderColor(255,0,0)
		end

		ResolveNPCPositions(cre:GetAbsOrigin(),65)

		table.insert(caster.tUnits,cre)
	end


end