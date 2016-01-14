function Acid(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities
	local target = event.target
	
	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_kret_acid_main_target", nil)

	for _,unit in pairs(targets) do 
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_kret_acid_all_target", nil)
	end
end