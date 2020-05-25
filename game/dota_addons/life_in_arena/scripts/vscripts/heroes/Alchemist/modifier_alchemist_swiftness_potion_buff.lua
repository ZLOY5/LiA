
modifier_alchemist_swiftness_potion_buff = class({})

function modifier_alchemist_swiftness_potion_buff:IsHidden()
	return false
end

function modifier_alchemist_swiftness_potion_buff:IsPurgable()
	return true
end

function modifier_alchemist_swiftness_potion_buff:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

function modifier_alchemist_swiftness_potion_buff:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_swiftness_potion_buff:HeroEffectPriority()
	return 10
end

function modifier_alchemist_swiftness_potion_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alchemist_swiftness_potion_buff:OnCreated(kv)
	if self:GetCaster():HasScepter() then
		self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_scepter")
	else
		self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end


function modifier_alchemist_swiftness_potion_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_alchemist_swiftness_potion_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
