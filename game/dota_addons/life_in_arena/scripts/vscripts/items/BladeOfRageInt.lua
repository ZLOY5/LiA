function OnCreatedModifier(event)
	local intAdd = event.caster:GetBaseIntellect()*event.int_percent*0.01
	event.caster:ModifyIntellect(intAdd)
	event.caster:CalculateStatBonus()
	event.caster.bladeOfRage_intBonus = intAdd
end

function OnDestroyModifier(event)
	event.caster:ModifyIntellect(-event.caster.bladeOfRage_intBonus)
	event.caster:CalculateStatBonus()
end