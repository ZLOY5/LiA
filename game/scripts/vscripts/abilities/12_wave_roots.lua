function Roots(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Hero_Treant.Overgrowth.Cast")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_entangling_roots", nil)
end