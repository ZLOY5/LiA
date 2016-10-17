function OnCreatedModifier(event)
	local strAdd = event.caster:GetBaseStrength()*event.str_percent*0.01
	event.caster:ModifyStrength(strAdd)
	event.caster:CalculateStatBonus()
	event.caster.bladeOfRage_strBonus = strAdd
end

function OnDestroyModifier(event)
	local caster = event.caster
	caster:AddNewModifier(caster,nil,"modifier_stats_bonus_fix",{strFix = caster.bladeOfRage_strBonus})
	caster:ModifyStrength(-caster.bladeOfRage_strBonus)
	caster:CalculateStatBonus()
end