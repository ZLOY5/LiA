modifier_minotaur_fear_aura = class({})

function modifier_minotaur_fear_aura:IsHidden() 
	return true 
end

function modifier_minotaur_fear_aura:IsPurgable()
	return false
end


function modifier_minotaur_fear_aura:AllowIllusionDuplicate()
	return false
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:GetModifierAura()
	return "modifier_minotaur_fear_effect"
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_minotaur_fear_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

