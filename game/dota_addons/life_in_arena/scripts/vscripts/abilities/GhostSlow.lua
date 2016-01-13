function Slow(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target

	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	
	if target:IsHero() then 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_16_wave_slow", {duration = hero_duration})	
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_16_wave_slow", {duration = duration})
	end
end