function StopTime(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	local heroDuration = ability:GetSpecialValueFor("hero_stop")
	local otherDuration = ability:GetSpecialValueFor("other_stop")
	local bonusDuration = ability:GetSpecialValueFor("bonus_duration")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_lock_bonus", {duration = bonusDuration})

	for _,unit in pairs(targets) do 
		if unit:IsRealHero() and string.find(unit:GetUnitName(),"megaboss") then
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_lock_stun_datadriven", {duration = heroDuration})
		else
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_lock_stun_datadriven", {duration = otherDuration})
		end
	end
end