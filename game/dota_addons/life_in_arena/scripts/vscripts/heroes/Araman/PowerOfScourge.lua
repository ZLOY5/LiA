function UpdateDamage(event)
	local caster = event.caster
	local ability = event.ability

	if not ability.damageStack then
		ability.damageStack = 0
	end

	if ability.damageStack < event.damage_stack_max-1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_araman_power_of_scourge_damage", nil)
		ability.damageStack = ability.damageStack + 1
	end

end

function RemoveDamage(event)
	local caster = event.caster
	local ability = event.ability

	while caster:HasModifier("modifier_araman_power_of_scourge_damage") do
		caster:RemoveModifierByName("modifier_araman_power_of_scourge_damage")
	end

	ability.damageStack = 0
	
end