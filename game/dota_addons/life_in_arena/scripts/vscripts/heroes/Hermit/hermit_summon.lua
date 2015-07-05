function summonCreate(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local durat = keys.durat
	--local scepter = keys.scepter
	local cre
	--
	local PID = caster:GetPlayerOwnerID()
	--
	local num = ability:GetSpecialValueFor( "unit_count" )
	local durat = ability:GetSpecialValueFor( "duration" )
	local obl = ability:GetSpecialValueFor( "spawn_radius" )
	
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
    --local playerID =player:GetPlayerID()
	--local target = keys.target --enemy
	--local target = keys.target_entities[1] --enemy
	--local target = keys.target
	--local targets = keys.target_entities
	local lvl = ability:GetLevel()-1
	local unitname
	--
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
	--
	--print("caster = ", caster:GetUnitName())
	--print("target = ", target:GetUnitName())
	--
	for i=1, num do
		cre = CreateUnitByName(unitname, caster:GetAbsOrigin() + RandomVector(RandomInt(-obl,obl )), false, caster, caster, caster:GetTeam())
		cre:SetControllableByPlayer(PID, false)
		--
		cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
		cre:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
		--
		if flag then
			cre:SetRenderColor(255,0,0)
		end
		--
		table.insert(caster.tUnits,cre)
	end

	
	--local cre = CreateUnitByName(unitname, target:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	--cre:SetControllableByPlayer(PID, false)
	--
	
	--cre:AddNewModifier(caster, nil, "modifier_kill", { duration = durat })
	--cre:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
	
	
	--ability:ApplyDataDrivenModifier( caster, cre, 'modifier_infection_expire', {} )
	--ability:ApplyDataDrivenModifier( caster, cre, 'modifier_phased', {duration = 0.03} )


end