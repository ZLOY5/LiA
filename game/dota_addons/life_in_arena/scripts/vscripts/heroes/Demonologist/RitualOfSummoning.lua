function GetPositionOnCircle(vCenter,vForward,flRadius,nPosition,nPositionCount)
	 local angle = nPosition / nPositionCount * 360
	 local QAngle = VectorToAngles(vForward)
	 QAngle.y = QAngle.y + angle
	 return RotatePosition(vCenter, QAngle, vCenter+vForward*flRadius)
end

function OnSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local default_creeps = ability:GetSpecialValueFor("unit_count")
	local additional_creeps = caster:GetIntellect() / ability:GetSpecialValueFor("intelligence_for_unit")
	local boss_count = ability:GetSpecialValueFor("boss_count")
	caster.demonologistUltimateCreepCount = math.floor(default_creeps + additional_creeps)
	caster.demonologistUltimateBossCount = boss_count

	if Survival.nRoundNum % 5 == 0 then
		caster.demonologistUltimateCreepCount = math.floor(caster.demonologistUltimateCreepCount/2)
	end
	if Survival.IsDuelOccured then
		caster.demonologistUltimateCreepCount = math.floor(caster.demonologistUltimateCreepCount/2)
		caster.demonologistUltimateBossCount = 0
	end

end

function SpawnUnits(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local lifetime = ability:GetSpecialValueFor("lifetime")
	

	local creep_name
	local boss_name

	if ((Survival.nRoundNum + 1) % 5 == 0) and (Survival.nRoundNum ~= 19) then
		creep_name = tostring(Survival.nRoundNum + 2).."_wave_creep"
		boss_name = tostring(Survival.nRoundNum + 2).."_wave_boss"
	elseif Survival.nRoundNum == 19 or Survival.nRoundNum == 20 then
		creep_name = "19_wave_creep"
		boss_name = "19_wave_boss"
	else
		creep_name = tostring(Survival.nRoundNum + 1).."_wave_creep"
		boss_name = tostring(Survival.nRoundNum + 1).."_wave_boss"
	end

	
	local radius = ability:GetSpecialValueFor("spawn_radius")
	local point = target:GetAbsOrigin()
    local points = caster.demonologistUltimateCreepCount

    if caster.demonologistUltimateBossCount > 0 then
	    for i=1,caster.demonologistUltimateBossCount do
	        local demonologistBoss = CreateUnitByName(boss_name, point, true, caster, caster, caster:GetTeam())
	        demonologistBoss:AddNewModifier(demonologistBoss, nil, "modifier_kill", {duration = lifetime})
	        demonologistBoss:AddNewModifier(demonologistBoss, nil, "modifier_demonologist_riual_of_summoning_status_effect", nil)
	        for k=0,15 do
				local abilityToRemove = demonologistBoss:GetAbilityByIndex(k)
				if abilityToRemove then
					if not abilityToRemove:IsPassive() then
						demonologistBoss:RemoveAbility(abilityToRemove:GetAbilityName())
					end
				end
			end
	        demonologistBoss.demonologistRitualCreep = true
			demonologistBoss:SetControllableByPlayer(caster:GetPlayerID(), true)
			ResolveNPCPositions(demonologistBoss:GetAbsOrigin(),100)
			demonologistBoss:SetAcquisitionRange(500)
	    end
	end

    for i=1,points do
        local position = GetPositionOnCircle(point,Vector(1,0,0),radius,i,points)
        local demonologistCreep = CreateUnitByName(creep_name, position, true, caster, caster, caster:GetTeam())
        demonologistCreep:AddNewModifier(demonologistCreep, nil, "modifier_kill", {duration = lifetime})
        demonologistCreep:AddNewModifier(demonologistCreep, nil, "modifier_demonologist_riual_of_summoning_status_effect", nil)
        for k=0,15 do
			local abilityToRemove = demonologistCreep:GetAbilityByIndex(k)
			if abilityToRemove then
				if not abilityToRemove:IsPassive() then
					demonologistCreep:RemoveAbility(abilityToRemove:GetAbilityName())
				end
			end
		end
        demonologistCreep.demonologistRitualCreep = true
		demonologistCreep:SetControllableByPlayer(caster:GetPlayerID(), true)
		ResolveNPCPositions(demonologistCreep:GetAbsOrigin(),100)
		demonologistCreep::SetAcquisitionRange(500)
    end

	
end
