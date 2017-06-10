item_lia_blade_of_rage_str = class({})
LinkLuaModifier("modifier_item_lia_blade_of_rage_str","items/item_lia_blade_of_rage_str.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_blade_of_rage_str_active","items/item_lia_blade_of_rage_str.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_blade_of_rage_str:GetIntrinsicModifierName()
	return "modifier_item_lia_blade_of_rage_str"
end

function item_lia_blade_of_rage_str:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_lia_blade_of_rage_str_active", {duration = self:GetSpecialValueFor("duration")} )	
end

---------------------------------------

modifier_item_lia_blade_of_rage_str = class({})

function modifier_item_lia_blade_of_rage_str:IsHidden() 
	return true
end

function modifier_item_lia_blade_of_rage_str:IsPurgable()
	return false
end

function modifier_item_lia_blade_of_rage_str:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_blade_of_rage_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_item_lia_blade_of_rage_str:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function modifier_item_lia_blade_of_rage_str:GetModifierBonusStats_Strength()
	return self.bonusStrength 
end

function modifier_item_lia_blade_of_rage_str:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed
end

function modifier_item_lia_blade_of_rage_str:OnCreated()
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonusStrength = self:GetAbility():GetSpecialValueFor("bonus_strength") 
	self.bonusAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

-----------------------------------------------------

modifier_item_lia_blade_of_rage_str_active = class({})

function modifier_item_lia_blade_of_rage_str_active:IsBuff()
	return true
end

function modifier_item_lia_blade_of_rage_str_active:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_item_lia_blade_of_rage_str_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

if IsServer() then

	function modifier_item_lia_blade_of_rage_str_active:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		}
	 
		return funcs
	end

	function modifier_item_lia_blade_of_rage_str_active:GetModifierBonusStats_Strength()
		return self.bonusStrength 
	end

	function modifier_item_lia_blade_of_rage_str_active:OnCreated()
		self.bonusStrength = self:GetParent():GetBaseStrength() * self:GetAbility():GetSpecialValueFor("str_percent") / 100
		self:SetStackCount(self.bonusStrength)
	end

end

