function CalcRegeneration(event)
	local unit = event.target
	local regen = unit:GetBaseHealthRegen()*0.5
	unit:RemoveModifierByName("horn_regeneration")
	event.ability:ApplyDataDrivenModifier(event.caster, unit, "horn_regeneration", {regen = regen, duration = -1})
	print("Recalc")
end