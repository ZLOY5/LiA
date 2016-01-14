
function AddModifier(keys)
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	local duration 

	target:EmitSound("Hero_Pugna.Decrepify")
	
	if keys.target:IsHero() then
		duration = keys.ability:GetSpecialValueFor("duration_hero")
	else
		duration = keys.ability:GetSpecialValueFor("duration_other")
	end

	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, 'modifier_hermit_decrepify', {duration = duration} )
end


