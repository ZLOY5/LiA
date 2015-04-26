function modifier_item_lia_totem_of_persistence_block(keys)
	if not keys.target:HasModifier("modifier_item_lia_scepter_of_power") and not keys.target:HasModifier("modifier_item_lia_amulet_of_spell_shield") then
		keys.target:RemoveModifierByName("modifier_item_sphere_target")
	end
end