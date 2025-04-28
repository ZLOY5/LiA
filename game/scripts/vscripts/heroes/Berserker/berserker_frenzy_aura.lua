---@class berserker_frenzy_aura:CDOTA_Ability_Lua
berserker_frenzy_aura = class({})
LinkLuaModifier("modifier_berserker_frenzy_aura_aura","heroes/Berserker/berserker_frenzy_aura.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_berserker_frenzy_aura_effect","heroes/Berserker/berserker_frenzy_aura.lua",LUA_MODIFIER_MOTION_NONE)

function berserker_frenzy_aura:GetIntrinsicModifierName()
	return "modifier_berserker_frenzy_aura_aura"
end


---@class modifier_berserker_frenzy_aura_aura:CDOTA_Modifier_Lua
modifier_berserker_frenzy_aura_aura = class({})

function modifier_berserker_frenzy_aura_aura:IsHidden() return true end

function modifier_berserker_frenzy_aura_aura:IsPurgable() return false end

function modifier_berserker_frenzy_aura_aura:IsAura() return true end

function modifier_berserker_frenzy_aura_aura:GetModifierAura()
	return "modifier_berserker_frenzy_aura_effect"
end

function modifier_berserker_frenzy_aura_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_berserker_frenzy_aura_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_berserker_frenzy_aura_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_berserker_frenzy_aura_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_berserker_frenzy_aura_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_berserker_frenzy_aura_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end


---@class modifier_berserker_frenzy_aura_effect:CDOTA_Modifier_Lua
modifier_berserker_frenzy_aura_effect = class({})

function modifier_berserker_frenzy_aura_effect:IsHidden() return false end
function modifier_berserker_frenzy_aura_effect:IsPurgable() return false end

function modifier_berserker_frenzy_aura_effect:OnCreated(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_berserker_frenzy_aura_effect:OnRefresh(kv)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_berserker_frenzy_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end

function modifier_berserker_frenzy_aura_effect:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_attack_speed
end

function modifier_berserker_frenzy_aura_effect:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage
end