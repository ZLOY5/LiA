item_lia_blade_of_rage_agi = class({})
LinkLuaModifier("modifier_item_lia_blade_of_rage_agi","items/item_lia_blade_of_rage_agi.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_blade_of_rage_agi_active","items/item_lia_blade_of_rage_agi.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_blade_of_rage_agi:GetIntrinsicModifierName()
	return "modifier_item_lia_blade_of_rage_agi"
end

function item_lia_blade_of_rage_agi:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_lia_blade_of_rage_agi_active", {duration = self:GetSpecialValueFor("duration")} )	
end

---------------------------------------

modifier_item_lia_blade_of_rage_agi = class({})

function modifier_item_lia_blade_of_rage_agi:IsHidden() 
	return true
end

function modifier_item_lia_blade_of_rage_agi:IsPurgable()
	return false
end

function modifier_item_lia_blade_of_rage_agi:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_blade_of_rage_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_item_lia_blade_of_rage_agi:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function modifier_item_lia_blade_of_rage_agi:GetModifierBonusStats_Agility()
	return self.bonusAgility
end

function modifier_item_lia_blade_of_rage_agi:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed
end

function modifier_item_lia_blade_of_rage_agi:OnCreated()
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonusAgility = self:GetAbility():GetSpecialValueFor("bonus_agility") 
	self.bonusAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

-----------------------------------------------------

modifier_item_lia_blade_of_rage_agi_active = class({})

function modifier_item_lia_blade_of_rage_agi_active:IsBuff()
	return true
end

function modifier_item_lia_blade_of_rage_agi_active:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_item_lia_blade_of_rage_agi_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

if IsServer() then

	function modifier_item_lia_blade_of_rage_agi_active:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		}
	 
		return funcs
	end

	function modifier_item_lia_blade_of_rage_agi_active:GetModifierBonusStats_Agility()
		return self.bonusAgility
	end

	function modifier_item_lia_blade_of_rage_agi_active:OnCreated()
		self.bonusAgility = self:GetParent():GetBaseAgility() * self:GetAbility():GetSpecialValueFor("agi_percent") / 100
		self:SetStackCount(self.bonusAgility)
	end

end

