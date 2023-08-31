modifier_wave_13_command_aura = class({})

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:GetModifierAura()
	return "modifier_wave_13_command_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


modifier_wave_13_command_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura_effect:OnCreated( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_13_command_aura_effect:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return self.bonus_damage_pct
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

