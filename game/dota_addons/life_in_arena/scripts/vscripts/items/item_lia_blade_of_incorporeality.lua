item_lia_blade_of_incorporeality = class({})
LinkLuaModifier("modifier_blade_of_incorporeality","items/item_lia_blade_of_incorporeality.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blade_of_incorporeality_active","items/item_lia_blade_of_incorporeality.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_blade_of_incorporeality:GetIntrinsicModifierName()
	return "modifier_blade_of_incorporeality"
end

function item_lia_blade_of_incorporeality:OnSpellStart() 
	if IsServer() then
		self.active_duration = self:GetSpecialValueFor("active_duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_blade_of_incorporeality_active", {duration = self.active_duration})
		self:GetCaster():EmitSound("Hero_ElderTitan.AncestralSpirit.Cast")
	end
end

-------------------------------------------------------------------------------

modifier_blade_of_incorporeality = class({})

function modifier_blade_of_incorporeality:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_blade_of_incorporeality:IsHidden()
	return true 
end

function modifier_blade_of_incorporeality:IsPurgable()
	return false 
end

function modifier_blade_of_incorporeality:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_blade_of_incorporeality:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_blade_of_incorporeality:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_blade_of_incorporeality:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_blade_of_incorporeality:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_blade_of_incorporeality:GetModifierEvasion_Constant()
	if self:GetParent():HasModifier("modifier_blade_of_incorporeality_active") then
		return self.active_evasion
	end
	
	return self.evasion
end

function modifier_blade_of_incorporeality:OnCreated(kv)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
	self.active_evasion = self:GetAbility():GetSpecialValueFor("active_evasion")
end


-------------------------------------------------------------------------------

modifier_blade_of_incorporeality_active = class({})

function modifier_blade_of_incorporeality_active:IsHidden()
	return false 
end

function modifier_blade_of_incorporeality_active:IsPurgable()
	return true 
end

function modifier_blade_of_incorporeality_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_blade_of_incorporeality_active:OnTooltip( params )
	return self.active_evasion
end

function modifier_blade_of_incorporeality_active:GetEffectName()
	return "particles/custom/items/item_lia_blade_of_incorporeality.vpcf"
end

function modifier_blade_of_incorporeality_active:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_blade_of_incorporeality_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_blade_of_incorporeality_active:StatusEffectPriority()
	return 15
end

function modifier_blade_of_incorporeality_active:OnCreated(kv)
	self.active_evasion = self:GetAbility():GetSpecialValueFor("active_evasion")
end