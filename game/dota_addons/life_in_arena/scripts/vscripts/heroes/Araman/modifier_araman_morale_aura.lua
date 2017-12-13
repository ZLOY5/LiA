
modifier_araman_morale_aura = class({})


function modifier_araman_morale_aura:IsHidden() 
	return true 
end

function modifier_araman_morale_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:GetModifierAura()
	return "modifier_araman_morale_effect"
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_araman_morale_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end


