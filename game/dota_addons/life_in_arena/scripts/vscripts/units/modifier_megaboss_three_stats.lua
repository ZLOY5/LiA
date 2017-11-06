modifier_megaboss_three_stats = class({})

--------------------------------------------------------------------------------

function modifier_megaboss_three_stats:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_megaboss_three_stats:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_megaboss_three_stats:OnCreated()
	if IsServer() then
		local multiplier = Survival:GetHeroCount(false)
		self.health_per_player = 1500 * multiplier
		self.damage_per_player = 150 * multiplier
		self.armor_per_player = 15 * multiplier
		self:GetParent():SetPhysicalArmorBaseValue(80 + self.armor_per_player)
	end
end

-----------------------------------------------------------------------------

function modifier_megaboss_three_stats:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_megaboss_three_stats:GetModifierExtraHealthBonus()
	return self.health_per_player
end

--------------------------------------------------------------------------------

function modifier_megaboss_three_stats:GetModifierBaseAttack_BonusDamage()
	return self.damage_per_player
end

--------------------------------------------------------------------------------

