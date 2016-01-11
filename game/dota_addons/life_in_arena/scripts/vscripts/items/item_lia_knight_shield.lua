item_lia_knight_shield = class({})
LinkLuaModifier("modifier_item_lia_knight_shield", "items/modifier_item_lia_knight_shield.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_knight_shield:GetIntrinsicModifierName() 
	return "modifier_item_lia_knight_shield"
end
								
function item_lia_knight_shield:OnItemEquipped(hItem) --вот это говно не работает
	print("!")
	if self:GetCaster():HasItemInInventory("item_lia_knight_cuirass") or self:GetCaster():HasItemInInventory("item_lia_knight_shield") then
		Timers:CreateTimer(0.01,function()
			self:GetCaster():DropItemAtPositionImmediate(self, self:GetCaster():GetAbsOrigin())
			FireGameEvent( 'custom_error_show', { player_ID = self:GetCaster():GetPlayerOwnerID(), _error = "#lia_hud_error_cant_have_two_items_retdmg" } )
		end)
	end
end