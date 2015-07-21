function OnCreatedModifier(event)
	local agiAdd = event.caster:GetBaseAgility()*event.agi_percent*0.01
	event.caster:ModifyAgility(agiAdd)
	event.caster:CalculateStatBonus()
	event.caster.bladeOfRage_agiBonus = agiAdd
end

function OnDestroyModifier(event)
	event.caster:ModifyAgility(-event.caster.bladeOfRage_agiBonus)
	event.caster:CalculateStatBonus()
end