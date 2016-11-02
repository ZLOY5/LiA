modifier_item_shield_of_death_armor = class({})


function modifier_item_shield_of_death_armor:IsHidden()
	return false
end

function modifier_item_shield_of_death_armor:IsPurgable()
	return true
end

function modifier_item_shield_of_death_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_item_shield_of_death_armor:OnCreated(kv)
	self.armorBonus = self:GetAbility():GetSpecialValueFor("active_armor")
end

function modifier_item_shield_of_death_armor:GetModifierPhysicalArmorBonus(params)
	if self:GetParent():HasModifier("modifier_item_lia_armor_of_the_red_mist_armor") then
		return 0
	else
		return self.armorBonus
	end
end