function SharpClaws(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	if caster:PassivesDisabled() then return end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_7_wave_sharp_claws_debuff", {duration = ability:GetSpecialValueFor("duration")})
end