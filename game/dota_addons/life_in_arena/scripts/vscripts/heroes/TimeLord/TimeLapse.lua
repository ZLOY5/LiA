function TickLapse(keys)
	local caster = keys.caster
	local ability = keys.ability

	if not ability.coordinatTable or ability.lastGameState ~= Survival.State then
		ability.coordinatTable = {} 
	end

	local delay_lapse = 5
	local time_tick = 0.1

	local count_tick = math.modf(delay_lapse/time_tick)

	if #ability.coordinatTable == count_tick then
		table.remove(ability.coordinatTable,1) -- удаляем первый элемент так, как он самый старый
	end 

	ability.lastGameState = Survival.State

	table.insert(ability.coordinatTable,{caster:GetAbsOrigin(),caster:GetHealth(),caster:GetMana()}) -- в конец добавляем новый элемент 
end


function TimeLapse(keys)
	local caster = keys.caster
	local ability = keys.ability

	local damage = ability:GetSpecialValueFor("damage")
	local damage_radius = ability:GetSpecialValueFor("damage_radius")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_lord_timelapse_invul", nil)

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)

	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Timers:CreateTimer(0.1,
		function()
			if not caster:IsAlive() then
				return
			end

			if ability.coordinatTable ~= nil then
				FindClearSpaceForUnit(caster, ability.coordinatTable[1][1], true)
				caster:SetHealth(ability.coordinatTable[1][2])
				--caster:SetMana(ability.coordinatTable[1][3])
			end

			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,unit in pairs(targets) do 
				ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			end

			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
	
			caster:RemoveModifierByName("modifier_time_lord_timelapse_invul")
			
		end
	)
end 
