modifier_guardian_spirit = class({}) 

function modifier_guardian_spirit:IsHidden()
	return true 
end

function modifier_guardian_spirit:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_guardian_spirit:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		--MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		--MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		--MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
 
	return funcs
end

--function modifier_guardian_spirit:GetModifierMoveSpeedBonus_Percentage(params)
--	return self.moveSpeedBonus
--end

function modifier_guardian_spirit:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus
end

function modifier_guardian_spirit:GetModifierBaseAttack_BonusDamage(params)
	return self.attackBonus
end

function modifier_guardian_spirit:GetModifierHealthBonus(params)
	return self.healthBonus
end

function modifier_guardian_spirit:GetModifierConstantHealthRegen(params)
	return self.healtRegenBonus
end

function modifier_guardian_spirit:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackSpeedBonus
end

function modifier_guardian_spirit:GetModifierManaBonus(params)
	return	self.manaBonus
end

function modifier_guardian_spirit:GetModifierConstantManaRegen(params)
	return self.manaRegenBonus
end

function modifier_guardian_spirit:OnCreated(kv)
	if IsServer() then 
		self.attackBonus = kv.intellect * 1.5

		self.healthBonus = kv.strength * HERO_STATS_HEALTH_BONUS
		self.healtRegenBonus = kv.strength * HERO_STATS_HEALTH_REGEN_BONUS
		
		self.armorBonus = kv.agility * HERO_STATS_ARMOR_BONUS
		self.attackSpeedBonus = kv.agility * HERO_STATS_ATTACK_SPEED_BONUS
		--self.moveSpeedBonus = kv.agility * HERO_STATS_MOVE_SPEED_BONUS -- в доте нет его?

		self.manaBonus = kv.intellect * HERO_STATS_MANA_BONUS
		self.manaRegenBonus = kv.intellect * HERO_STATS_MANA_REGEN_BONUS 
	end
end
