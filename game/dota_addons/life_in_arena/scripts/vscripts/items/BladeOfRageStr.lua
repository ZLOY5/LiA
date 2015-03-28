function OnCreatedModifier(event)
	local strAdd = event.caster:GetStrength()*event.str_percent*0.01
	event.caster:ModifyStrength(strAdd)
	event.caster:CalculateStatBonus()
	event.ability.strAdd = strAdd
end

function OnDestroyModifier(event)
	event.caster:ModifyAgility(-event.ability.strAdd)
	event.caster:CalculateStatBonus()
end