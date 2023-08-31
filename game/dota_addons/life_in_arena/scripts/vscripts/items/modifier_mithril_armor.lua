modifier_mithril_armor = class({})

function modifier_mithril_armor:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_mithril_armor:IsHidden()
	return true 
end

function modifier_mithril_armor:IsPurgable()
	return false
end

function modifier_mithril_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
 
	return funcs
end

function modifier_mithril_armor:OnCreated(kv)
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.blockDamage = self:GetAbility():GetSpecialValueFor("damage_blocked")
end

function modifier_mithril_armor:GetModifierPhysical_ConstantBlock(params)
	if not params.inflictor then 
		return self.blockDamage
	end
end

function modifier_mithril_armor:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_mithril_armor:GetModifierPhysicalArmorBonus()
	return self.armorBonus
end