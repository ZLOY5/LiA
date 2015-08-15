function MagicArrow(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	for _,unit in pairs(targets) do 
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_dark_ranger_magic_arrow_all_target", nil)
	end
end