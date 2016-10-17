function OnCreatedModifier(event)
	local target = event.target
	local modifier = target:FindModifierByNameAndCaster("modifier_item_lunar_necklace",event.caster)
	
	local agiAdd = target:GetBaseAgility()*event.stat_percent*0.01
	local strAdd = target:GetBaseStrength()*event.stat_percent*0.01
	local intAdd = target:GetBaseIntellect()*event.stat_percent*0.01

	if agiAdd > event.stat_bonus_max then 
		agiAdd = event.stat_bonus_max
	end
	if strAdd > event.stat_bonus_max then 
		strAdd = event.stat_bonus_max
	end
	if intAdd > event.stat_bonus_max then 
		intAdd = event.stat_bonus_max
	end

	target:ModifyAgility(agiAdd)
	target:ModifyStrength(strAdd)
	target:ModifyIntellect(intAdd)	
	target:CalculateStatBonus()

	local duration = event.ability:GetSpecialValueFor("duration")

	Timers:CreateTimer(duration,
		function()
			target:ModifyAgility(-agiAdd)

			target:AddNewModifier(target,nil,"modifier_stats_bonus_fix",{strFix = strAdd})
			target:ModifyStrength(-strAdd)
			
			target:ModifyIntellect(-intAdd)	

			target:CalculateStatBonus()
		end
	)
end
