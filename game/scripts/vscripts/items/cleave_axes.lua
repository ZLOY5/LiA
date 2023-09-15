function OnEquipHugeAxe(event)
	Timers:CreateTimer(0.01,function()
		if event.caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
			print("Huge Axe pick up")
			if not event.caster:HasModifier("item_blood_moon_cleave_modifier") then
				local item = GetItemInInventory(event.caster,"item_lia_huge_axe")
				item:ApplyDataDrivenModifier(event.caster, event.caster, "item_huge_axe_cleave_modifier", nil) 
				print("Huge Axe modifier added")
			end
		end
	end)
end

function OnEquipBloodMoon(event)
	Timers:CreateTimer(0.01,function()
		if event.caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
			print("Blood Moon pick up")
			event.caster:RemoveModifierByName("item_huge_axe_cleave_modifier")
			local item = GetItemInInventory(event.caster,"item_lia_blood_moon")
			item:ApplyDataDrivenModifier(event.caster, event.caster, "item_blood_moon_cleave_modifier", nil) 
			print("Blood Moon modifier added")
		end
	end)
end

function OnUnequip(event)
	if not event.caster:HasModifier("modifier_item_lia_huge_axe") then
		event.caster:RemoveModifierByName("item_huge_axe_cleave_modifier")
		print("Huge Axe modifier removed")
	end
	if not event.caster:HasModifier("modifier_item_blood_moon") then
		event.caster:RemoveModifierByName("item_blood_moon_cleave_modifier")
		print("Blood Moon modifier removed")
		if event.caster:HasModifier("modifier_item_lia_huge_axe") then
			local item = GetItemInInventory(event.caster,"item_lia_huge_axe")
			item:ApplyDataDrivenModifier(event.caster, event.caster, "item_huge_axe_cleave_modifier", nil) 	
			print("Huge Axe modifier added")
		end
	end
end