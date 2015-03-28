function OnCreatedModifier(event)
	local agiAdd = event.caster:GetAgility()*event.agi_percent*0.01
	event.caster:ModifyAgility(agiAdd)
	event.caster:CalculateStatBonus()
	event.ability.agiAdd = agiAdd
end

function OnDestroyModifier(event)
	event.caster:ModifyAgility(-event.ability.agiAdd)
	event.caster:CalculateStatBonus()
end