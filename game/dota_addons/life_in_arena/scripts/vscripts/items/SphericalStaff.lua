function modifier_item_spherical_staff_datadriven_on_created(keys)
	if not keys.caster:HasModifier("modifier_item_ultimate_scepter") then
		keys.caster:AddNewModifier(keys.caster, nil, "modifier_item_ultimate_scepter", {duration = -1})
	end
end


function modifier_item_spherical_staff_datadriven_on_destroy(keys)
	local num_scepters_in_inventory = 0

	for i=0, 5, 1 do  --Search for Aghanim's Scepters in the player's inventory.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item ~= nil then
			local item_name = current_item:GetName()
			
			if item_name == "item_lia_spherical_staff" then
				num_scepters_in_inventory = num_scepters_in_inventory + 1
			end
		end
	end

	--Remove the stock Aghanim's Scepter modifier if the player no longer has a scepter in their inventory.
	if num_scepters_in_inventory == 0 and keys.caster:HasModifier("modifier_item_ultimate_scepter") then
		keys.caster:RemoveModifierByName("modifier_item_ultimate_scepter")
	end
end

function RenderInferno(event)
   event.target:SetRenderColor(128, 255, 0)
end