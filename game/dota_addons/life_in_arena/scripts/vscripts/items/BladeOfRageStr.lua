function OnCreatedModifier(event)
	local strAdd = event.caster:GetBaseStrength()*event.str_percent*0.01
	event.caster:ModifyStrength(strAdd)
	event.caster:CalculateStatBonus()
	event.caster.bladeOfRage_strBonus = strAdd
end

function OnDestroyModifier(event)
	event.caster:ModifyStrength(-event.caster.bladeOfRage_strBonus)
	event.caster:CalculateStatBonus()
end