function heal(trigger)
	local ent = trigger.activator
	ent:AddNewModifier(trigger.activator, nil, "modifier_rune_regen", nil)
end

function noheal(trigger)
	local ent = trigger.activator
	ent:RemoveModifierByName("modifier_rune_regen")
end