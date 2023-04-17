item_lia_magician_armor = class({})
LinkLuaModifier("modifier_item_lia_magician_armor","items/item_lia_magician_armor.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_magician_armor:GetIntrinsicModifierName()
	return "modifier_item_lia_magician_armor"
end

-------------------------------------------------------------------------------

modifier_item_lia_magician_armor = class({})

function modifier_item_lia_magician_armor:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_magician_armor:IsHidden()
	return true 
end

function modifier_item_lia_magician_armor:IsPurgable()
	return false 
end

function modifier_item_lia_magician_armor:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	self.bonus_mana_regeneration = self:GetAbility():GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_spell_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_spell_damage_percentage")
	self.bonus_debuff_duration_percentage = self:GetAbility():GetSpecialValueFor("bonus_debuff_duration_percentage")
end

function modifier_item_lia_magician_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
	}
 
	return funcs
end

function modifier_item_lia_magician_armor:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_item_lia_magician_armor:GetModifierConstantManaRegen()
	return self.bonus_mana_regeneration
end

function modifier_item_lia_magician_armor:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_lia_magician_armor:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_lia_magician_armor:GetModifierSpellAmplify_Percentage()
	return self.bonus_spell_damage_percentage
end

function modifier_item_lia_magician_armor:GetModifierStatusResistanceCaster()
	return -self.bonus_debuff_duration_percentage
end
