function StealShadow(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	local duration = ability:GetSpecialValueFor("duration")

	for _,unit in pairs(targets) do 
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_steal_shadow", {duration = duration})
	end

	ability.targets = targets
end