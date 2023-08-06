
modifier_frost_lord_ice_debuff = class({})

function modifier_frost_lord_ice_debuff:IsHidden()
	return false
end

function modifier_frost_lord_ice_debuff:IsPurgable()
	return true
end

function modifier_frost_lord_ice_debuff:OnCreated(kv)
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor("movement_slow_percentage")
end

function modifier_frost_lord_ice_debuff:OnRefresh(kv)
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor("movement_slow_percentage")
end

function modifier_frost_lord_ice_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

function modifier_frost_lord_ice_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percentage
end
