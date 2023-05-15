modifier_berserker_fire_spear_debuff = class({})

function modifier_berserker_fire_spear_debuff:IsHidden()
	return false
end

function modifier_berserker_fire_spear_debuff:IsPurgable()
	return false
end

function modifier_berserker_fire_spear_debuff:OnCreated(kv)
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor("movement_slow_percentage")
end

function modifier_berserker_fire_spear_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

function modifier_berserker_fire_spear_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.movement_slow_percentage
end

function modifier_berserker_fire_spear_debuff:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_berserker_fire_spear_debuff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
