modifier_stats_bonus_fix = class({})

function modifier_stats_bonus_fix:IsHidden()
	return true 
end

function modifier_stats_bonus_fix:IsPurgable()
	return false
end

function modifier_stats_bonus_fix:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_stats_bonus_fix:RemoveOnDeath()
	return false
end

function modifier_stats_bonus_fix:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
 
	return funcs
end

--function modifier_stats_bonus_fix:GetModifierMoveSpeedBonus_Percentage(params)
--	return self.moveSpeedBonus
--end


function modifier_stats_bonus_fix:GetModifierBaseAttack_BonusDamage(params)
	return self.attackBonus
end

function modifier_stats_bonus_fix:GetModifierHealthBonus(params)
	return self.healthBonus
end

function modifier_stats_bonus_fix:GetModifierConstantHealthRegen(params)
	return self.healtRegenBonus
end

function modifier_stats_bonus_fix:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackSpeedBonus
end

function modifier_stats_bonus_fix:GetModifierManaBonus(params)
	return	self.manaBonus
end

function modifier_stats_bonus_fix:GetModifierConstantManaRegen(params)
	return self.manaRegenBonus
end

function modifier_stats_bonus_fix:CalculateStatsBonus(kv) 
	local hero = self:GetParent()

	if not hero:IsHero() then
		return
	end

	local primaryStat = hero:GetPrimaryStatValue()
	local strength = hero:GetStrength() - (kv.strFix or 0)
	local agility = hero:GetAgility()
	local intellect = hero:GetIntellect()

	self.attackBonus = primaryStat * (HERO_STATS_ATTACK_BONUS - 1)

	self.healthBonus = strength * (HERO_STATS_HEALTH_BONUS - 20)
	self.healtRegenBonus = strength * (HERO_STATS_HEALTH_REGEN_BONUS - 0.03)
	

	hero.baseArmorValue = hero.baseArmorValue or hero:GetPhysicalArmorBaseValue()
	
	self.armorBonus = agility * (HERO_STATS_ARMOR_BONUS - 1/7) --в доте за 7 ловкости дают 1 ед. защиты
	hero:SetPhysicalArmorBaseValue(self.armorBonus+hero.baseArmorValue) 
	
	self.attackSpeedBonus = agility * (HERO_STATS_ATTACK_SPEED_BONUS - 1)
	self.moveSpeedBonus = agility * HERO_STATS_MOVE_SPEED_BONUS -- в доте нет его?

	self.manaBonus = intellect * (HERO_STATS_MANA_BONUS - 12)
	self.manaRegenBonus = intellect * (HERO_STATS_MANA_REGEN_BONUS - 0.04)

	hero:CalculateStatBonus()

end

function modifier_stats_bonus_fix:OnCreated(kv)
	if IsServer() then
		self:CalculateStatsBonus(kv) 
		self:StartIntervalThink(0.03)
	end
end


function modifier_stats_bonus_fix:OnRefresh(kv)
	if IsServer() then
		self:CalculateStatsBonus(kv) 
	end
end

function modifier_stats_bonus_fix:OnIntervalThink()
	self:CalculateStatsBonus({})
end