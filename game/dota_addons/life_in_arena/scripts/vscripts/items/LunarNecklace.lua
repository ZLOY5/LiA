function OnCreatedModifier(event)
	local agiAdd = event.target:GetAgility()*event.stat_percent*0.01
	local strAdd = event.target:GetStrength()*event.stat_percent*0.01
	local intAdd = event.target:GetIntellect()*event.stat_percent*0.01
	event.target:ModifyAgility(agiAdd)
	event.target:ModifyStrength(strAdd)
	event.target:ModifyIntellect(intAdd)	
	event.target:CalculateStatBonus()
	event.ability.agiAdd = agiAdd
	event.ability.strAdd = strAdd
	event.ability.intAdd = intAdd	
end

function OnDestroyModifier(event)
	event.target:ModifyAgility(-event.ability.agiAdd)
	event.target:ModifyStrength(-event.ability.strAdd)
	event.target:ModifyIntellect(-event.ability.intAdd)	
	event.target:CalculateStatBonus()
end