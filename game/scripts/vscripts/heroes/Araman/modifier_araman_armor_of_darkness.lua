modifier_araman_armor_of_darkness = class({})

function modifier_araman_armor_of_darkness:IsHidden()
	return true
end

function modifier_araman_armor_of_darkness:IsPurgable()
	return false
end

function modifier_araman_armor_of_darkness:OnCreated(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_araman_armor_of_darkness:OnRefresh(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_araman_armor_of_darkness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_araman_armor_of_darkness:GetModifierIncomingPhysicalDamage_Percentage()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.incoming_damage_percentage
end

function modifier_araman_armor_of_darkness:GetModifierPhysicalArmorBonus()
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	
	return self.bonus_armor
end