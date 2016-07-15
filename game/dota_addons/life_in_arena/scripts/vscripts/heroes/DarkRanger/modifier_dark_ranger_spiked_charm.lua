modifier_dark_ranger_spiked_charm = class({})

function modifier_dark_ranger_spiked_charm:IsHidden() 
	return true 
end

function modifier_dark_ranger_spiked_charm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:GetModifierAura()
	return "modifier_dark_ranger_spiked_charm_aura"
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_dark_ranger_spiked_charm:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end
