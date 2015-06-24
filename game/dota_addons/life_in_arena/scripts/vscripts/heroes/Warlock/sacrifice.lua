

function changeAll(caster, radius, change_per_teak)

	local table_target = FindUnitsInRadius(caster:GetTeam(),
                                 caster:GetAbsOrigin(),
                                 nil,
                                 radius,
                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                 DOTA_UNIT_TARGET_FLAG_NONE,
                                 FIND_ANY_ORDER,
                                 false)
	for _,unit in pairs(table_target) do
   		if unit ~= caster then
   			unit:SetHealth(unit:GetHealth()+unit:GetMaxHealth()*change_per_teak )
   			unit:SetMana(unit:GetMana()+unit:GetMaxMana()*change_per_teak )                          
   		end

	end
	
	return nil
end



function Director(keys)

	local caster = keys.caster
	local ability = keys.ability

	local radius = keys.radius
	local barrier_reduction = keys.barrier_reduction/100
	local change_per_teak = keys.change_per_teak/100

	local changeMana = caster:GetMaxMana()*change_per_teak
	local changeHp = caster:GetMaxHealth()*change_per_teak
	local reduction = caster:GetMaxHealth()*barrier_reduction

	changeAll(caster, radius, change_per_teak )--Лечим 
	caster:ReduceMana( changeMana )

	if caster:GetHealth()-changeHp > reduction then       --Проверка уровня хп после уменьшения
  		caster:SetHealth(caster:GetHealth()-changeHp ) 
	else
		caster:SetHealth( reduction )
		give_invulnerability(caster, radius, ability)
		caster:RemoveModifierByName("modifier_sacrifice")
		ability:EndChannel(true)
	end	
end


function give_invulnerability(caster, radius, ability)

	local table_target = FindUnitsInRadius(caster:GetTeam(),   --DOTA_TEAM_GOODGUYS,
                                 caster:GetAbsOrigin(),
                                 nil,
                                 radius,
                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                 DOTA_UNIT_TARGET_FLAG_NONE,
                                 FIND_ANY_ORDER,
                                 false)
	for _,unit in pairs(table_target) do
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_sacrifice_invulnerability", {} )
	end

	return nil 
end
