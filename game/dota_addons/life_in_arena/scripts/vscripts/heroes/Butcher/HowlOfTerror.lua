function HowlOfTerror( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local duration = ability:GetSpecialValueFor("duration")

	if string.find(target:GetUnitName(),"megaboss") or target:IsHero() then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_butcher_howl_of_terror",{duration = duration/2})
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_butcher_howl_of_terror",{duration = duration})
	end
end