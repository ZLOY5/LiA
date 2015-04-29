function OnUnequip(event)
	local itemName = event.ability:GetAbilityName()
	local item = GetItemInInventory(event.caster,itemName)
	if item then
		item:ApplyDataDrivenModifier(event.caster, event.caster, event.ModifierName, nil)
	end
end