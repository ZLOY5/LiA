if modifier_lia_shadow == nil then
	modifier_lia_shadow = class({})
end

function modifier_lia_shadow:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_lia_shadow:IsHidden()
	return true
end

function modifier_lia_shadow:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_lia_shadow:StatusEffectPriority()
	return 100
end

function modifier_lia_shadow:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		--MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		--MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end


--function modifier_lia_shadow:GetModifierMoveSpeedBonus_Percentage(params)
--	return self.moveSpeedBonus
--end

function modifier_lia_shadow:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus
end

function modifier_lia_shadow:GetModifierBaseAttack_BonusDamage(params)
	return self.attackBonus
end

function modifier_lia_shadow:GetModifierHealthBonus(params)
	return self.healthBonus
end

function modifier_lia_shadow:GetModifierConstantHealthRegen(params)
	return self.healtRegenBonus
end

function modifier_lia_shadow:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackSpeedBonus
end

function modifier_lia_shadow:GetModifierManaBonus(params)
	return	self.manaBonus
end

function modifier_lia_shadow:GetModifierConstantManaRegen(params)
	return self.manaRegenBonus
end

function modifier_lia_shadow:OnCreated(kv)
	if IsServer() then 
		self.attackBonus = kv.agility * HERO_STATS_ATTACK_BONUS

		self.healthBonus = kv.strength * HERO_STATS_HEALTH_BONUS
		self.healtRegenBonus = kv.strength * HERO_STATS_HEALTH_REGEN_BONUS
		
		self.armorBonus = kv.agility * HERO_STATS_ARMOR_BONUS
		self.attackSpeedBonus = kv.agility * HERO_STATS_ATTACK_SPEED_BONUS
		--self.moveSpeedBonus = kv.agility * HERO_STATS_MOVE_SPEED_BONUS -- в доте нет его?

		self.manaBonus = kv.intellect * HERO_STATS_MANA_BONUS
		self.manaRegenBonus = kv.intellect * HERO_STATS_MANA_REGEN_BONUS 
	end
end

function modifier_lia_shadow:OnDeath(params)
	if IsServer() then 
		if params.unit == self:GetParent() then
			params.unit:AddNoDraw()
			ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
		end
	end
end