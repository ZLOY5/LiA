function Thirst(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	local health_percent = ability:GetSpecialValueFor("activation_health_percent")
	local thirst_points_bonus = ability:GetSpecialValueFor("thirst_points_bonus")

	if caster:PassivesDisabled() then
		return 
	end
	
	for _,unit in pairs(targets) do 
		if unit:GetHealthPercent() < health_percent then 
			if not caster:HasModifier("modifier_vampire_thirst_bonus") then 
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_vampire_thirst_bonus", nil)
				if caster.thirst_points then
					caster.thirst_points = caster.thirst_points + thirst_points_bonus
					if caster.thirst_points > caster.thirst_points_max then 
						caster.thirst_points = caster.thirst_points_max 
					end
					
					local modifier = caster:FindModifierByName("modifier_vampire_lifesteal")
					if modifier then
						modifier:SetStackCount(caster.thirst_points)
					end
				end
			end
			return
		end
	end
	caster:RemoveModifierByName("modifier_vampire_thirst_bonus") -- удаляем модификатор, если рядом нет врагов удовлетворяющих условию
end
