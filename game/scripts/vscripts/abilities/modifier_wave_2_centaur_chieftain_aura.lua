modifier_wave_2_centaur_chieftain_aura = class({})

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:GetModifierAura()
	return "modifier_wave_2_centaur_chieftain_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_wave_2_centaur_chieftain_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

