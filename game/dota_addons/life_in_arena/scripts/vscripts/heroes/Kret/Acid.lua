function Acid(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	for _,unit in pairs(targets) do 
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_kret_acid_all_target", nil)
	end
end