modifier_witch_doctor_frost_armor_buff = class({})

function modifier_witch_doctor_frost_armor_buff:IsHidden()
	return false
end

function modifier_witch_doctor_frost_armor_buff:IsPurgable()
	return true
end

function modifier_witch_doctor_frost_armor_buff:OnCreated(kv)
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	if self:GetCaster():HasScepter() then
		self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus_scepter" )
	else
		self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	end
end

function modifier_witch_doctor_frost_armor_buff:OnRefresh(kv)
	if self:GetCaster():HasScepter() then
		self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus_scepter" )
	else
		self.armor_bonus = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	end
end

function modifier_witch_doctor_frost_armor_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_witch_doctor_frost_armor_buff:OnAttackLanded(params)
	if params.target == self:GetParent() and not params.attacker:IsMagicImmune() then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_witch_doctor_frost_armor_debuff", {duration = self.slow_duration})
		
	end
end

function modifier_witch_doctor_frost_armor_buff:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end

function modifier_witch_doctor_frost_armor_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_armor.vpcf"
end

function modifier_witch_doctor_frost_armor_buff:StatusEffectPriority()
	return 15
end

function modifier_witch_doctor_frost_armor_buff:GetEffectName()
	return "particles/units/heroes/hero_lich/lich_frost_armor.vpcf"
end

function modifier_witch_doctor_frost_armor_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end