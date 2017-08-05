modifier_armor_of_the_red_mist = class({})

function modifier_armor_of_the_red_mist:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_armor_of_the_red_mist:IsHidden()
	return true 
end

function modifier_armor_of_the_red_mist:IsPurgable()
	return false
end

function modifier_armor_of_the_red_mist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
 
	return funcs
end

function modifier_armor_of_the_red_mist:OnCreated(kv)
	self.healthBonus = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.blockDamage = self:GetAbility():GetSpecialValueFor("damage_blocked")
	self.bonusMagicResist =  self:GetAbility():GetSpecialValueFor("bonus_magic_resist_percentage")
end

function modifier_armor_of_the_red_mist:GetModifierPhysical_ConstantBlock(params)
	if not params.inflictor then 
		return self.blockDamage
	end
end

function modifier_armor_of_the_red_mist:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_armor_of_the_red_mist:GetModifierPhysicalArmorBonus()
	return self.armorBonus
end

function modifier_armor_of_the_red_mist:GetModifierMagicalResistanceBonus()
	return self.bonusMagicResist
end