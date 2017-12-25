
modifier_minotaur_fear_effect = class({})

function modifier_minotaur_fear_effect:IsHidden()
	return false
end

function modifier_minotaur_fear_effect:IsPurgable()
	return false
end

function modifier_minotaur_fear_effect:OnCreated(kv)
	self.penalty_armor = self:GetAbility():GetSpecialValueFor("penalty_armor")
end

function modifier_minotaur_fear_effect:OnRefresh(kv)
	self.penalty_armor = self:GetAbility():GetSpecialValueFor("penalty_armor")
end

function modifier_minotaur_fear_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_minotaur_fear_effect:GetModifierPhysicalArmorBonus()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.penalty_armor
end

