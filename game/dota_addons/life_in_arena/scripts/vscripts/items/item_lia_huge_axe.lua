item_lia_huge_axe = class({})
LinkLuaModifier("modifier_item_lia_huge_axe","items/item_lia_huge_axe.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_huge_axe_cleave","items/item_lia_huge_axe.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_huge_axe:GetIntrinsicModifierName()
	return "modifier_item_lia_huge_axe"
end

---------------------------------------

modifier_item_lia_huge_axe = class({})

function modifier_item_lia_huge_axe:IsHidden() 
	return true
end

function modifier_item_lia_huge_axe:IsPurgable()
	return false
end

function modifier_item_lia_huge_axe:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_huge_axe:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength") 

	if IsServer() then
		if self.parent:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then 
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_lia_huge_axe_cleave", {})
		end
	end
end

function modifier_item_lia_huge_axe:OnDestroy()
	if IsServer() then
		if not self.parent:HasModifier("modifier_item_lia_huge_axe") then 
			self.parent:RemoveModifierByName("modifier_item_lia_huge_axe_cleave")
		end
	end
end

function modifier_item_lia_huge_axe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
 
	return funcs
end

function modifier_item_lia_huge_axe:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_huge_axe:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

---------------------------------------

modifier_item_lia_huge_axe_cleave = class({})

function modifier_item_lia_huge_axe_cleave:IsHidden() 
	return true
end

function modifier_item_lia_huge_axe_cleave:IsPurgable()
	return false
end

function modifier_item_lia_huge_axe_cleave:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
end

function modifier_item_lia_huge_axe_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
 
	return funcs
end

function modifier_item_lia_huge_axe_cleave:GetModifierProcAttack_Feedback(params)
	if IsServer() then
		if self.parent:HasModifier("modifier_item_lia_blood_moon_cleave") then return end
		local damage = params.damage * self.damage_percent / 100

		DoCleaveAttack_IgnorePhysicalArmor(self.parent,	params.target, self.ability, damage, self.radius_start, self.radius_end, self.radius_dist, "particles/custom/items/cleave.vpcf")
	end
end
