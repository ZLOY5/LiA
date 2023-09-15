function OnIntervalThinkAura(event)
	local unit = event.target
	if unit:GetHealthPercent() < event.aura_health_perc_max then
		event.ability:ApplyDataDrivenModifier(event.caster, unit, "item_staff_of_light_aura_regen_modifier", nil)
	else
		unit:RemoveModifierByName("item_staff_of_light_aura_regen_modifier")
	end
end

function OnSpellStart(event)
	local targets = event.target_entities
	local item = event.ability
	local caster = event.caster
	for _,target in pairs(targets) do 
		item:ApplyDataDrivenModifier(caster, target, "item_staff_of_light_ability_damage_modifier", nil)
	end
	if #targets > 0 then
		item:ApplyDataDrivenModifier(caster, caster, "item_staff_of_light_ability_heal_modifier", nil)
		item.target_entities = targets
	end

end

function OnAbilityModifierDestroy(event)
	local target = event.target
	local targets = event.ability.target_entities
	for k,v in pairs(targets) do
		if target == v then
			table.remove(targets, k)
		end
	end
	if #targets == 0 then
		event.caster:RemoveModifierByName("item_staff_of_light_ability_heal_modifier") 
	end
end
