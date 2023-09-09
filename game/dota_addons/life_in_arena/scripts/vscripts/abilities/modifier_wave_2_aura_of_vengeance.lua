modifier_wave_2_aura_of_vengeance = class({})

function modifier_wave_2_aura_of_vengeance:IsHidden() 
	return true 
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:GetModifierAura()
	return "modifier_wave_2_aura_of_vengeance_aura"
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_wave_2_aura_of_vengeance:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end
