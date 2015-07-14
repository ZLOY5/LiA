function OnCreatedModifier(event)
	local target = event.target
	local modifier = target:FindModifierByNameAndCaster("modifier_item_lunar_necklace",event.caster)
	
	local agiAdd = target:GetAgility()*event.stat_percent*0.01
	local strAdd = target:GetStrength()*event.stat_percent*0.01
	local intAdd = target:GetIntellect()*event.stat_percent*0.01
	
	target:ModifyAgility(agiAdd)
	target:ModifyStrength(strAdd)
	target:ModifyIntellect(intAdd)	
	target:CalculateStatBonus()

	local duration = event.ability:GetSpecialValueFor("duration")

	Timers:CreateTimer(duration,
		function()
			target:ModifyAgility(-agiAdd)
			target:ModifyStrength(-strAdd)
			target:ModifyIntellect(-intAdd)	
			target:CalculateStatBonus()
		end
	)
end
