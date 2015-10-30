
function AddModifier(keys)
	local duration 

	if keys.target:IsHero() then
		duration = keys.ability:GetSpecialValueFor("duration_hero")
	else
		duration = keys.ability:GetSpecialValueFor("duration_other")
	end

	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, 'modifier_hermit_decrepify', {duration = duration} )
end


