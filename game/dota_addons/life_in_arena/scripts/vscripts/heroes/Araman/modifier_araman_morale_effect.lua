modifier_araman_morale_effect = class({})

function modifier_araman_morale_effect:IsHidden()
	return false
end

function modifier_araman_morale_effect:IsPurgable()
	return false
end

function modifier_araman_morale_effect:OnCreated(kv)
	self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
end

function modifier_araman_morale_effect:OnRefresh(kv)
	self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
end

function modifier_araman_morale_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
 
	return funcs
end

function modifier_araman_morale_effect:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage_percentage
end

