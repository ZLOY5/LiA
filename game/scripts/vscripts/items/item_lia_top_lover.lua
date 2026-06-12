item_lia_top_lover = class({})
LinkLuaModifier("modifier_item_lia_top_lover", "items/item_lia_top_lover.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_top_lover_ability", "items/item_lia_top_lover.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_top_lover:GetIntrinsicModifierName()
	return "modifier_item_lia_top_lover"
end

function item_lia_top_lover:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_lia_top_lover_ability",
		{ duration = self:GetSpecialValueFor("duration") } )
	self:GetCaster():EmitSound("DOTA_Item.BladeMail.Activate")
end


-----------------------------------------------------------

modifier_item_lia_top_lover = class ({})


function modifier_item_lia_top_lover:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_top_lover:IsHidden() return true end

function modifier_item_lia_top_lover:IsPurgable() return false end

function modifier_item_lia_top_lover:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		Timers:CreateTimer(0.01,function()
			if parent:HasItemInInventory("item_lia_knight_shield",false,self:GetAbility()) 
			or parent:HasItemInInventory("item_lia_knight_cuirass",false,self:GetAbility())  
			or parent:HasItemInInventory("item_lia_top_lover",false,self:GetAbility()) then
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
	self.intelligence = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	self.reflectPercent = self:GetAbility():GetSpecialValueFor("damage_return") / 100
	self.intBonus = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	self.eros_charge_limit = self:GetAbility():GetSpecialValueFor("eros_charge_limit")
	self.eros_dmg_per_charge = self:GetAbility():GetSpecialValueFor("eros_dmg_per_charge")
	self.eros_duration = self:GetAbility():GetSpecialValueFor("eros_duration")
	self.charges = 0
end

function modifier_item_lia_top_lover:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
 
	return funcs
end

function modifier_item_lia_top_lover:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_item_lia_top_lover:GetModifierPhysicalArmorBonus()
	return self.armorBonus
end

function modifier_item_lia_top_lover:GetModifierBonusStats_Intellect()
	return self.intBonus 
end

function modifier_item_lia_top_lover:OnAttackLanded(params) 
	if params.target == self:GetParent() and not params.ranged_attack and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end


function modifier_item_lia_top_lover:OnTakeDamage(params)

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
		
		local reflect_percent
		if params.unit:HasModifier("modifier_item_lia_top_lover_ability") then 
			reflect_percent = self.reflectPercentActive
			self:GetCaster():EmitSound("DOTA_Item.BladeMail.Damage")
		else 
			reflect_percent = self.reflectPercent
		end 

		local return_damage = reflect_percent * params.original_damage

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

function modifier_item_lia_top_lover:OnAbilityFullyCast(params)
	if IsServer() then  
		--PrintTable("OnAbilityFullyCast",params)
		if params.unit == self:GetCaster() and not self:GetParent():IsInvulnerable() then 
			if params.ability:IsToggle() and not params.ability:IsPermanent() or params.ability:GetAbilityName() == "item_lia_seal_of_power_armor" or params.ability:GetAbilityName() == "item_lia_seal_of_power_damage" then
				return 
			end
			if self.charges < self.eros_charge_limit then 
				self.charges = self.charges + 1 
			end
		end
	end 
end


--------------------------------------------------------------------------------

modifier_item_lia_top_lover_ability = class({})

function modifier_item_lia_top_lover_ability:IsPurgable()
	return false 
end

function modifier_item_lia_top_lover_ability:GetEffectName()
	return "particles/lotus_orb_shell_custom.vpcf"
end

function modifier_item_lia_top_lover_ability:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_lia_top_lover_ability:IsBuff()
	return true 
end

function modifier_item_lia_top_lover_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

function modifier_item_lia_top_lover_ability:OnTooltip(params)
	local netTable = CustomNetTables:GetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ) )
	return netTable.ritual_protection_damage_absorb
end

function modifier_item_lia_top_lover_ability:GetBlockDamage(attack_damage)
	local parent = self:GetParent()

	local damage_block

	if self.damage_absorb > attack_damage then 
		damage_block = attack_damage
		self.damage_absorb = self.damage_absorb - damage_block

		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { ritual_protection_damage_absorb = self.damage_absorb } )
	else 
		damage_block = self.damage_absorb 
		self:Destroy()
	end
	
	return damage_block
end

function modifier_item_lia_top_lover_ability:OnCreated(kv)
	if IsServer() then
		self.damage_absorb = self:GetAbility():GetSpecialValueFor( "damage_absorb" )
		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { ritual_protection_damage_absorb = self.damage_absorb } )
	end
end