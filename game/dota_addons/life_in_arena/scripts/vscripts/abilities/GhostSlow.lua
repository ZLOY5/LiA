function Slow(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local hero_duration = ability:GetSpecialValueFor("hero_duration")
	local duration = ability:GetSpecialValueFor("duration")


	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Hero_Visage.GraveChill.Cast")
	if target:IsHero() then 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_16_wave_slow", {duration = hero_duration})	
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_16_wave_slow", {duration = duration})
	end
end