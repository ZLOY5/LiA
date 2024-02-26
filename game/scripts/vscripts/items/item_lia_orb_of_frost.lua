item_lia_orb_of_frost = class({})

LinkLuaModifier("modifier_item_lia_orb_of_frost", "items/item_lia_orb_of_frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_orb_of_frost_aura_effect", "items/item_lia_orb_of_frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_orb_of_frost_slow", "items/item_lia_orb_of_frost", LUA_MODIFIER_MOTION_NONE)

function item_lia_orb_of_frost:GetIntrinsicModifierName()
	return "modifier_item_lia_orb_of_frost"
end

---@class modifier_item_lia_orb_of_frost:CDOTA_Modifier_Lua
modifier_item_lia_orb_of_frost = class({})

function modifier_item_lia_orb_of_frost:IsHidden() return true end
function modifier_item_lia_orb_of_frost:IsPurgable() return false end
function modifier_item_lia_orb_of_frost:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_orb_of_frost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_item_lia_orb_of_frost:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_lia_orb_of_frost:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.orb_duration = self.ability:GetSpecialValueFor("orb_duration")
end

function modifier_item_lia_orb_of_frost:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_orb_of_frost:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_lia_orb_of_frost:GetOrbProjectileName()
	return "particles/items2_fx/skadi_projectile.vpcf"
end

-- function modifier_item_lia_orb_of_frost:OnOrbFire()
-- 	self.parent:EmitSound("Hero_Jakiro.Attack")
-- end

function modifier_item_lia_orb_of_frost:OnOrbImpact(event)
	event.target:AddNewModifier(self.parent, self.ability, "modifier_item_lia_orb_of_frost_slow", {duration = self.orb_duration})
end

function modifier_item_lia_orb_of_frost:IsAura()
	return true
end

function modifier_item_lia_orb_of_frost:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_lia_orb_of_frost:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_lia_orb_of_frost:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_lia_orb_of_frost:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_item_lia_orb_of_frost:GetAuraDuration()
	return 1
end

function modifier_item_lia_orb_of_frost:GetModifierAura()
	return "modifier_item_lia_orb_of_frost_aura_effect"
end

---@class modifier_item_lia_orb_of_frost_aura_effect:CDOTA_Modifier_Lua
modifier_item_lia_orb_of_frost_aura_effect = class({})

function modifier_item_lia_orb_of_frost_aura_effect:IsHidden() return false end
function modifier_item_lia_orb_of_frost_aura_effect:IsPurgable() return false end

function modifier_item_lia_orb_of_frost_aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_lia_orb_of_frost_aura_effect:OnCreated()
	self.ability = self:GetAbility()
	self.aura_attack_speed = self.ability:GetSpecialValueFor("aura_attack_speed")
	self.aura_movement_speed = self.ability:GetSpecialValueFor("aura_movement_speed")
end

function modifier_item_lia_orb_of_frost_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.aura_movement_speed
end

function modifier_item_lia_orb_of_frost_aura_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_attack_speed
end

---@class modifier_item_lia_orb_of_frost_slow:CDOTA_Modifier_Lua
modifier_item_lia_orb_of_frost_slow = class({})

function modifier_item_lia_orb_of_frost_slow:IsHidden() return false end
function modifier_item_lia_orb_of_frost_slow:IsPurgable() return true end

function modifier_item_lia_orb_of_frost_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_lia_orb_of_frost_slow:OnCreated()
	self.ability = self:GetAbility()
	self.orb_movespeed_slow = self.ability:GetSpecialValueFor("orb_movespeed_slow")
	self.orb_attack_slow = self.ability:GetSpecialValueFor("orb_attack_slow")
end

function modifier_item_lia_orb_of_frost_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.orb_movespeed_slow
end

function modifier_item_lia_orb_of_frost_slow:GetModifierAttackSpeedBonus_Constant()
	return self.orb_attack_slow
end

function modifier_item_lia_orb_of_frost_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_item_lia_orb_of_frost_slow:StatusEffectPriority()
	return 10
end
