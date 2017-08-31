item_lia_knight_shield = class({})
LinkLuaModifier("modifier_item_lia_knight_shield", "items/item_lia_knight_shield.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_knight_shield:GetIntrinsicModifierName()
	return "modifier_item_lia_knight_shield"
end

function item_lia_knight_shield:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_lia_knight_shield_ability",
		{ duration = self:GetSpecialValueFor("duration") } )
	self:GetCaster():EmitSound("???")
end


-----------------------------------------------------------

modifier_item_lia_knight_shield = class ({})


function modifier_item_lia_knight_shield:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_knight_shield:IsHidden()
	return true
end

function modifier_item_lia_knight_shield:IsPurgable()
	return false
end

function modifier_item_lia_knight_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end


function modifier_item_lia_knight_shield:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_item_lia_knight_shield:GetModifierPhysicalArmorBonus()
	return self.armorBonus
end

function modifier_item_lia_knight_shield:OnAttackLanded(params) 
	if params.target == self:GetParent() and not params.ranged_attack and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end


function modifier_item_lia_knight_shield:OnTakeDamage(params)

	if self:GetParent():PassivesDisabled() then
		return
	end

	if self.attack_record == params.record then

		if params.unit:HasModifier("modifier_brain_storm_decrepify") 
		or params.unit:HasModifier("modifier_hermit_decrepify") 
		or params.unit:HasModifier("modifier_illusionist_mastery_of_illusions") 
		or params.unit:HasModifier("modifier_decrepify_hero") then
			return
		end


		local return_damage = self.reflectPercent * params.original_damage

		ApplyDamage(
		{
			victim = params.attacker, 
			attacker = params.unit, 
			damage = return_damage, 
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility()
		})
	end

end

function modifier_item_lia_knight_shield:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		Timers:CreateTimer(0.01,function()
			if parent:HasItemInInventory("item_lia_knight_shield",false,self:GetAbility()) 
			or parent:HasItemInInventory("item_lia_knight_cuirass",false,self:GetAbility()) then
				local swapped = false
				for i=6,8 do
		            if parent:GetItemInSlot(i) == nil then 
		            	parent:SwapItems(i,self:GetAbility():GetItemSlot())
		                swapped = true
		                break
		            end
		        end
		        if not swapped then
		           	parent:DropItemAtPositionImmediate(self:GetAbility(),parent:GetAbsOrigin())
		        end
		        SendErrorMessage(parent:GetPlayerID(), "#lia_hud_error_cant_have_two_items_retdmg")
			end
		end)
	end

	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")

	self.reflectPercent = self:GetAbility():GetSpecialValueFor("damage_return") / 100

end
