function OnAttacked(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability

	if RollPercentage(ability:GetSpecialValueFor("chance"))
		if attacker:IsRangedAttacker() then 
			ability:ApplyDataDrivenModifier(target, target, "modifier_earth_lord_stone_skin_ranged_no_damage", nil)
		else 
			ability:ApplyDataDrivenModifier(target, attacker, "modifier_earth_lord_stone_skin_melee_damage_reduction", nil)
		end
	end

end