function Banish(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Hero_Pugna.Decrepify")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_decrepify_hero",  {duration = ability:GetSpecialValueFor("duration_on_hero")})
end