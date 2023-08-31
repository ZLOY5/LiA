function KnightCuirassShield(event)
	if event.caster:HasItemInInventory("item_lia_knight_cuirass") or event.caster:HasItemInInventory("item_lia_knight_shield") then
		--CreateItem(event.ability:GetAbilityName(), event.caster, event.caster)
		--event.caster:RemoveItem(event.ability)
		Timers:CreateTimer(0.01,function()
			event.caster:DropItemAtPositionImmediate(event.ability, event.caster:GetAbsOrigin())
			FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_cant_have_two_items_retdmg" } )
		end)
	end
end

function DivineArmor(event)
	if event.caster:HasItemInInventory("item_lia_divine_armor",false,event.ability) then
		Timers:CreateTimer(0.01,function()
			event.caster:DropItemAtPositionImmediate(event.ability, event.caster:GetAbsOrigin())
			FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_cant_have_two_divine_armor" } )
		end)
	end
end