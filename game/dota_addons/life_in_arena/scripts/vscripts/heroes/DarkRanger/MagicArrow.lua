function MagicArrow(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities

	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_ranger_magic_arrow_main_targe", nil)
	for _,unit in pairs(targets) do 
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_dark_ranger_magic_arrow_all_target", nil)
	end
end