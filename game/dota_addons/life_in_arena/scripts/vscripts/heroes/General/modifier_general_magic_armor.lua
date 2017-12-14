
modifier_general_magic_armor = class({})

function modifier_general_magic_armor:IsHidden()
	return true
end

function modifier_general_magic_armor:IsPurgable()
	return false
end

function modifier_general_magic_armor:OnCreated(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
end

function modifier_general_magic_armor:OnRefresh(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
end

function modifier_general_magic_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_general_magic_armor:GetModifierIncomingPhysicalDamage_Percentage()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.incoming_damage_percentage
end
