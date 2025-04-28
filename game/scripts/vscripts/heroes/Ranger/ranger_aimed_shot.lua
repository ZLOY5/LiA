---@class ranger_aimed_shot:CDOTA_Ability_Lua
ranger_aimed_shot = class({})
LinkLuaModifier("modifier_ranger_aimed_shot_aura","heroes/Ranger/ranger_aimed_shot.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ranger_aimed_shot_effect","heroes/Ranger/ranger_aimed_shot.lua",LUA_MODIFIER_MOTION_NONE)

function ranger_aimed_shot:GetIntrinsicModifierName()
	return "modifier_ranger_aimed_shot_aura"
end


---@class modifier_ranger_aimed_shot_aura:CDOTA_Modifier_Lua
modifier_ranger_aimed_shot_aura = class({})

function modifier_ranger_aimed_shot_aura:IsHidden() return true end

function modifier_ranger_aimed_shot_aura:IsPurgable() return false end

function modifier_ranger_aimed_shot_aura:IsAura() return true end

function modifier_ranger_aimed_shot_aura:GetModifierAura()
	return "modifier_ranger_aimed_shot_effect"
end

function modifier_ranger_aimed_shot_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ranger_aimed_shot_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_ranger_aimed_shot_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY
end

function modifier_ranger_aimed_shot_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_ranger_aimed_shot_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_ranger_aimed_shot_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end


---@class modifier_ranger_aimed_shot_effect:CDOTA_Modifier_Lua
modifier_ranger_aimed_shot_effect = class({})

function modifier_ranger_aimed_shot_effect:IsHidden() return false end
function modifier_ranger_aimed_shot_effect:IsPurgable() return false end

function modifier_ranger_aimed_shot_effect:OnCreated(kv)
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
end

function modifier_ranger_aimed_shot_effect:OnRefresh(kv)
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
end

function modifier_ranger_aimed_shot_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
 
	return funcs
end

function modifier_ranger_aimed_shot_effect:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage_pct
end