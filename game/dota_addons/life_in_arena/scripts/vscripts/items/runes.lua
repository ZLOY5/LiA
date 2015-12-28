function RuneOfStrength(event)
	event.caster:ModifyStrength(1)
	event.caster:CalculateStatBonus()
end

function RuneOfAgility(event)
	event.caster:ModifyAgility(1)
	event.caster:CalculateStatBonus()
end

function RuneOfIntellect(event)
	event.caster:ModifyIntellect(1)
	event.caster:CalculateStatBonus()
end