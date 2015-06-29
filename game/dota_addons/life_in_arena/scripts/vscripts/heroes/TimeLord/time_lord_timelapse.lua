function TickLapse(keys)
	local caster = keys.caster
	local ability = keys.ability

	if not ability.coordinatTable then
		ability.coordinatTable = {} 
	end

	local delay_lapse = 5
	local time_tick = 0.2

	local count_tick = math.modf(delay_lapse/time_tick)

	if #ability.coordinatTable == count_tick then
		table.remove(ability.coordinatTable,1) -- Удаляем, первый элемент так, как он самый старый
	end 

	table.insert(ability.coordinatTable,{caster:GetAbsOrigin(),caster:GetHealth(),caster:GetMana()}) -- В конец добавляем новый элемент, ибо надо продолжить вечный цикл замещения 
end


function TimeLapse(keys)
	local caster = keys.caster
	local ability = keys.ability

	FindClearSpaceForUnit(caster, ability.coordinatTable[1][1],true )
	caster:SetHealth(ability.coordinatTable[1][2])
	caster:SetMana(ability.coordinatTable[1][3])
end 
