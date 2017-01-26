item_lia_blade_of_rage_int = class({})
LinkLuaModifier("modifier_item_lia_blade_of_rage_int","items/item_lia_blade_of_rage_int.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_blade_of_rage_int_active","items/item_lia_blade_of_rage_int.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_blade_of_rage_int:GetIntrinsicModifierName()
	return "modifier_item_lia_blade_of_rage_int"
end

function item_lia_blade_of_rage_int:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_lia_blade_of_rage_int_active", {duration = self:GetSpecialValueFor("duration")} )	
end

---------------------------------------

modifier_item_lia_blade_of_rage_int = class({})

function modifier_item_lia_blade_of_rage_int:IsHidden() 
	return true
end

function modifier_item_lia_blade_of_rage_int:IsPurgable()
	return false
end

function modifier_item_lia_blade_of_rage_int:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_blade_of_rage_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_item_lia_blade_of_rage_int:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function modifier_item_lia_blade_of_rage_int:GetModifierBonusStats_Intellect()
	return self.bonusIntellect
end

function modifier_item_lia_blade_of_rage_int:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed
end

function modifier_item_lia_blade_of_rage_int:OnCreated()
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonusIntellect = self:GetAbility():GetSpecialValueFor("bonus_intellect") 
	self.bonusAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

-----------------------------------------------------

modifier_item_lia_blade_of_rage_int_active = class({})

function modifier_item_lia_blade_of_rage_int_active:IsBuff()
	return true
end

function modifier_item_lia_blade_of_rage_int_active:GetEffectName()
	return "particles/morphling_morph_int.vpcf"
end

function modifier_item_lia_blade_of_rage_int_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

if IsServer() then

	function modifier_item_lia_blade_of_rage_int_active:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		}
	 
		return funcs
	end

	function modifier_item_lia_blade_of_rage_int_active:GetModifierBonusStats_Intellect()
		return self.bonusIntellect
	end

	function modifier_item_lia_blade_of_rage_int_active:OnCreated()
		self.bonusIntellect = self:GetParent():GetBaseIntellect() * self:GetAbility():GetSpecialValueFor("int_percent") / 100
		self:SetStackCount(self.bonusIntellect)
	end

end

