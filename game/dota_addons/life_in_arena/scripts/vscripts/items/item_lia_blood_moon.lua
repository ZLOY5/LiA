item_lia_blood_moon = class({})
LinkLuaModifier("modifier_item_lia_blood_moon","items/item_lia_blood_moon.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_blood_moon_cleave","items/item_lia_blood_moon.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_blood_moon:GetIntrinsicModifierName()
	return "modifier_item_lia_blood_moon"
end

---------------------------------------

modifier_item_lia_blood_moon = class({})

function modifier_item_lia_blood_moon:IsHidden() 
	return true
end

function modifier_item_lia_blood_moon:IsPurgable()
	return false
end

function modifier_item_lia_blood_moon:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_blood_moon:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength") 
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed") 

	if IsServer() then
		if self.parent:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then 
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_lia_blood_moon_cleave", {})
		end
	end
end

function modifier_item_lia_blood_moon:OnDestroy()
	if IsServer() then
		if not self.parent:HasModifier("modifier_item_lia_blood_moon") then 
			self.parent:RemoveModifierByName("modifier_item_lia_blood_moon_cleave")
		end
	end
end

function modifier_item_lia_blood_moon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_item_lia_blood_moon:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_blood_moon:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_lia_blood_moon:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

---------------------------------------

modifier_item_lia_blood_moon_cleave = class({})

function modifier_item_lia_blood_moon_cleave:IsHidden() 
	return false
end

function modifier_item_lia_blood_moon_cleave:IsPurgable()
	return false
end

function modifier_item_lia_blood_moon_cleave:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage_percent = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")
end

function modifier_item_lia_blood_moon_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
 
	return funcs
end

function modifier_item_lia_blood_moon_cleave:GetModifierProcAttack_Feedback(params)
	if IsServer() then
		local damage = params.damage * self.damage_percent / 100

		DoCleaveAttack_IgnorePhysicalArmor(self.parent,	params.target, self.ability, damage, self.radius_start, self.radius_end, self.radius_dist, "particles/custom/items/cleave.vpcf")
	end
end
