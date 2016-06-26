modifier_item_lia_enchanted_shield = class({})

function modifier_item_lia_enchanted_shield:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_enchanted_shield:IsHidden()
	return true 
end

function modifier_item_lia_enchanted_shield:IsPurgable()
	return false
end

function modifier_item_lia_enchanted_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR,
	}
 
	return funcs
end

function modifier_item_lia_enchanted_shield:OnCreated(kv)
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.blockChance = self:GetAbility():GetSpecialValueFor("block_chance")
	self.blockDamage = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_item_lia_enchanted_shield:OnRefresh(kv)
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.blockChance = self:GetAbility():GetSpecialValueFor("block_chance")
	self.blockDamage = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_item_lia_enchanted_shield:GetModifierHealthBonus(params)
	return self.healthBonus
end

function modifier_item_lia_enchanted_shield:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus
end

function modifier_item_lia_enchanted_shield:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(params)
	if not params.inflictor and RollPercentage(self.blockChance) then 
		return self.blockDamage 
	end
	return 0
end