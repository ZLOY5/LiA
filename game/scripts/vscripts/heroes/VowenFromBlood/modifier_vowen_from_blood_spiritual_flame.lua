modifier_vowen_from_blood_spiritual_flame = class({})

function modifier_vowen_from_blood_spiritual_flame:IsBuff()
	return true 
end

function modifier_vowen_from_blood_spiritual_flame:IsHidden()
	return false 
end

function modifier_vowen_from_blood_spiritual_flame:IsPurgable()
	return true 
end

function modifier_vowen_from_blood_spiritual_flame:GetEffectName()
	return "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf"
end

function modifier_vowen_from_blood_spiritual_flame:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vowen_from_blood_spiritual_flame:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
 
	return funcs

end

function modifier_vowen_from_blood_spiritual_flame:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_vowen_from_blood_spiritual_flame:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_percentage
end

function modifier_vowen_from_blood_spiritual_flame:OnCreated(kv)
	if self:GetCaster():HasScepter() then
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen_scepter")
		self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage_scepter")
	else
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
		self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
	end
end

function modifier_vowen_from_blood_spiritual_flame:OnRefresh(kv)
	if self:GetCaster():HasScepter() then
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen_scepter")
		self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage_scepter")
	else
		self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
		self.bonus_damage_percentage = self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
	end
end
