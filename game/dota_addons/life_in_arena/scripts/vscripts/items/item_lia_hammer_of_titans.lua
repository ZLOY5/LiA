item_lia_hammer_of_titans = class({})
LinkLuaModifier("modifier_item_lia_hammer_of_titans","items/item_lia_hammer_of_titans.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_hammer_of_titans_debuff","items/item_lia_hammer_of_titans.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_hammer_of_titans:GetIntrinsicModifierName()
	return "modifier_item_lia_hammer_of_titans"
end

---------------------------------------

modifier_item_lia_hammer_of_titans = class({})

function modifier_item_lia_hammer_of_titans:IsHidden() 
	return true
end

function modifier_item_lia_hammer_of_titans:IsPurgable()
	return false
end

function modifier_item_lia_hammer_of_titans:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_hammer_of_titans:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength") 
	self.bonus_agility = self.ability:GetSpecialValueFor("bonus_agility") 
	self.bonus_intelligence = self.ability:GetSpecialValueFor("bonus_intelligence") 

	self.cleave = self.ability:GetSpecialValueFor("cleave_percent")
	self.radius_start = self.ability:GetSpecialValueFor("cleave_start_width")
	self.radius_end = self.ability:GetSpecialValueFor("cleave_end_width")
	self.radius_dist = self.ability:GetSpecialValueFor("cleave_length")

	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
end

function modifier_item_lia_hammer_of_titans:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
 
	return funcs
end

function modifier_item_lia_hammer_of_titans:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_hammer_of_titans:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_lia_hammer_of_titans:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_lia_hammer_of_titans:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_item_lia_hammer_of_titans:GetModifierProcAttack_Feedback(params)
	if IsServer() then
		if self.parent:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

		local damage = params.damage * self.cleave / 100

		-- cleave
		DoCleaveAttack(
			self.parent,
			params.target,
			self.ability,
			self.cleave,
			self.radius_start,
			self.radius_end,
			self.radius_dist,
			"particles/custom/items/hammer_of_titans_cleave.vpcf"
		)

		local direction = self.parent:GetForwardVector()
		local startPos = self.parent:GetAbsOrigin() + direction
		local endPos = self.parent:GetAbsOrigin() + direction * self.radius_dist

		local trapezoid_points = {startPos + self.radius_start * Vector(-direction.y, direction.x, 0), startPos + self.radius_start * Vector(direction.y, -direction.x, 0), endPos + self.radius_end * Vector(direction.y, -direction.x, 0), endPos + self.radius_end * Vector(-direction.y, direction.x, 0)}

		local cleaveTargets = FindUnitsInTrapezoid_TwoPoints(params.attacker:GetTeam(), startPos, endPos, nil, self.radius_start, self.radius_end, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)

		for k, v in pairs(cleaveTargets) do
			v:AddNewModifier(self.parent, self.ability, "modifier_item_lia_hammer_of_titans_debuff", {duration = self.slow_duration})
		end
	end
end

-----------------------------------------------------

modifier_item_lia_hammer_of_titans_debuff = class({})

function modifier_item_lia_hammer_of_titans_debuff:IsHidden() 
	return false
end

function modifier_item_lia_hammer_of_titans_debuff:IsPurgable()
	return true
end

function modifier_item_lia_hammer_of_titans_debuff:IsDebuff()
	return true
end

function modifier_item_lia_hammer_of_titans_debuff:OnCreated(kv)
	self.attack_speed_slow = self:GetAbility():GetSpecialValueFor("attack_speed_slow")
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor("movement_slow_percentage")
end

function modifier_item_lia_hammer_of_titans_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	
	return funcs
end

function modifier_item_lia_hammer_of_titans_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percentage
end

function modifier_item_lia_hammer_of_titans_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end

function modifier_item_lia_hammer_of_titans_debuff:GetEffectName()
	return "particles/custom/items/hammer_of_titans_debuff.vpcf"
end

function modifier_item_lia_hammer_of_titans_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




