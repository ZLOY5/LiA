function Cripple(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("DOTA_Item.RodOfAtos.Activate")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_item_rod_of_atos_datadriven_cripple", nil)
end