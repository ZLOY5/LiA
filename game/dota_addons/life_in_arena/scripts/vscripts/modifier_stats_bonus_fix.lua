modifier_stats_bonus_fix = class({})

ATTACK_BONUS = 1.5

--Strenght
HEALTH_BONUS = 8
HEALTH_REGEN_BONUS = 0.05

--Agility
ARMOR_BONUS = 0.2
ATTACK_SPEED_BONUS = 1
MOVE_SPEED_BONUS = 1

--Intellect
MANA_BONUS = 12
MANA_REGEN_BONUS = 0.05

function modifier_stats_bonus_fix:IsHidden()
	return true 
end

function modifier_stats_bonus_fix:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_stats_bonus_fix:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_stats_bonus_fix:GetModifierMoveSpeedBonus_Percentage(params)
	return self.moveSpeedBonus
end

function modifier_stats_bonus_fix:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus
end

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

function modifier_stats_bonus_fix:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_stats_bonus_fix:OnIntervalThink()
	local hero = self:GetParent()

	if not hero:IsHero() then
		return
	end
	
	local primaryStat = hero:GetPrimaryStatValue()
	local strength = hero:GetStrength()
	local agility = hero:GetAgility()
	local intellect = hero:GetIntellect()

	self.attackBonus = primaryStat * (ATTACK_BONUS - 1)

	self.healthBonus = strength * (HEALTH_BONUS - 19)
	self.healtRegenBonus = strength * (HEALTH_REGEN_BONUS - 0.03)
	
	self.armorBonus = agility * (ARMOR_BONUS - 1/7) --в доте за 7 ловкости дают 1 ед. защиты
	self.attackSpeedBonus = agility * (ATTACK_SPEED_BONUS - 1)
	self.moveSpeedBonus = agility * MOVE_SPEED_BONUS -- в доте нет его?

	self.manaBonus = intellect * (MANA_BONUS - 13)
	self.manaRegenBonus = intellect * (MANA_REGEN_BONUS - 0.04)

	hero:CalculateStatBonus()
end
