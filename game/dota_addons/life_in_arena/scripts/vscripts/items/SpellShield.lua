

--[[ ============================================================================================================
	Author: Rook
	Date: January 30, 2015
	Called when Linken's Sphere is picked up.  Makes sure the caster has a passive modifier_item_sphere_target if 
	the item is off cooldown.
================================================================================================================= ]]
function modifier_item_lia_amulet_of_spell_shield_on_created(keys)
	if keys.ability ~= nil and keys.ability:IsCooldownReady() then
		if keys.caster:HasModifier("modifier_item_sphere_target") then  --Remove any potentially temporary version of the modifier and replace it with an indefinite one.
			keys.caster:RemoveModifierByName("modifier_item_sphere_target")
		end
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_item_sphere_target", {duration = -1})
		keys.caster.current_spellblock_is_passive = true
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: January 30, 2015
	Called when Linken's Sphere is dropped, sold, etc.  Goes through the caster's inventory and determines whether
	they should still have a modifier_item_sphere_target.
================================================================================================================= ]]
function modifier_item_lia_amulet_of_spell_shield_on_destroy(keys)
	local ability = keys.ability
	local sphereModifier = keys.caster:FindModifierByName("modifier_item_sphere_target")
	if sphereModifier and sphereModifier:GetAbility() == ability then
		sphereModifier:Destroy()

		for i=0, 5, 1 do --Search for off-cooldown Linken's Spheres in the player's inventory.
			local current_item = keys.caster:GetItemInSlot(i)
			if current_item and current_item ~= ability then
				if (current_item:GetName() == "item_lia_staff_of_power" or current_item:GetName() == "item_lia_amulet_of_spell_shield") and current_item:IsCooldownReady() then
					keys.caster:AddNewModifier(keys.caster, current_item, "modifier_item_sphere_target", {duration = -1})
					return
				end
			end
		end
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: January 30, 2015
	Called regularly while at least one Linken's Sphere is in the player's inventory.  Tries to determine if the 
	modifier_item_sphere_target	modifier on the hero has been expended, and sets the Linken's Spheres in the player's
	inventory on cooldown if one has been.
================================================================================================================= ]]
function modifier_item_lia_amulet_of_spell_shield_on_interval_think(keys)
	local num_off_cooldown_linkens_spheres_in_inventory = 0
	for i=0, 5, 1 do --Search for off-cooldown Linken's Spheres in the player's inventory.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item then
			if (current_item:GetName() == "item_lia_spellbreaker" or current_item:GetName() == "item_lia_staff_of_power" or current_item:GetName() == "item_lia_amulet_of_spell_shield") and current_item:IsCooldownReady() then
				num_off_cooldown_linkens_spheres_in_inventory = num_off_cooldown_linkens_spheres_in_inventory + 1
			end
		end
	end

	if num_off_cooldown_linkens_spheres_in_inventory > 0 and not keys.caster:HasModifier("modifier_item_sphere_target") then
		if keys.caster.current_spellblock_is_passive == nil then  --If the Linken's Sphere just came off cooldown.
			keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_item_sphere_target", {duration = -1})
			keys.caster.current_spellblock_is_passive = true
		else  --keys.caster.current_spellblock_is_passive == true.
			--The Linken's was presumably popped passively.  Note that modifier_item_sphere_target is non-dispellable.
			keys.caster.current_spellblock_is_passive = nil
			for i=0, 5, 1 do --Put all Linken's Spheres in the player's inventory on cooldown.
				local current_item = keys.caster:GetItemInSlot(i)
				if current_item ~= nil then
					if current_item:GetName() == "item_lia_spellbreaker" or current_item:GetName() == "item_lia_staff_of_power" or current_item:GetName() == "item_lia_amulet_of_spell_shield" then
						current_item:StartCooldown(current_item:GetCooldown(current_item:GetLevel()))
					end
				end
			end
			num_off_cooldown_linkens_spheres_in_inventory = 0
		end
	end

end
