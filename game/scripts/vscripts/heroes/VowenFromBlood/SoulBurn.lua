function SoulBurn(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	
	local duration_hero = ability:GetSpecialValueFor("duration_hero")
	local duration_creep = ability:GetSpecialValueFor("duration_creep")
	local buff_duration = ability:GetSpecialValueFor("buff_duration")

	ability:ApplyDataDrivenModifier(caster, caster, "voven_from_blood_soul_burn_buff", {duration = buff_duration})

	if target:IsRealHero() then
		ability:ApplyDataDrivenModifier(caster, target, "voven_from_blood_soul_burn_debuff", {duration = duration_hero})
	else
		ability:ApplyDataDrivenModifier(caster, target, "voven_from_blood_soul_burn_debuff", {duration = duration_creep})
	end	

end