modifier_naga_royal_guard_persistence = class({})

function modifier_naga_royal_guard_persistence:IsHidden()
	return true
end

function modifier_naga_royal_guard_persistence:IsPurgable()
	return false
end

function modifier_naga_royal_guard_persistence:OnCreated(kv)
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_naga_royal_guard_persistence:OnRefresh(kv)
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_naga_royal_guard_persistence:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
 
	return funcs
end

function modifier_naga_royal_guard_persistence:GetModifierBonusStats_Strength()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.bonus_strength
end

function modifier_naga_royal_guard_persistence:GetModifierPhysicalArmorBonus()
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	
	return self.bonus_armor
end