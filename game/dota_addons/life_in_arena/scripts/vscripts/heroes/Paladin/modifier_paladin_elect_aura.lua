modifier_paladin_elect_aura = class({})

function modifier_paladin_elect_aura:IsHidden() 
	return true 
end

function modifier_paladin_elect_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:GetModifierAura()
	return "modifier_paladin_elect_effect"
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_paladin_elect_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

