function remove_agi(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	--
	caster.curr_agi = caster.curr_agi - target.bonus_agi
	caster:ModifyAgility(-target.bonus_agi)
	caster:CalculateStatBonus()
	
	
end