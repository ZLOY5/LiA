modifier_armor_of_the_red_mist_buff = class({})

function modifier_armor_of_the_red_mist_buff:IsPurgable()
	return true
end

function modifier_armor_of_the_red_mist_buff:IsBuff()
	return true
end

function modifier_armor_of_the_red_mist_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_armor_of_the_red_mist_buff:OnCreated(kv)
	self.armorBonus = self:GetAbility():GetSpecialValueFor("active_armor")
end

function modifier_armor_of_the_red_mist_buff:GetModifierPhysicalArmorBonus()
	return self.armorBonus
end