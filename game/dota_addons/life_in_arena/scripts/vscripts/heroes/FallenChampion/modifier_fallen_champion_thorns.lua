modifier_fallen_champion_thorns = class({})

function modifier_fallen_champion_thorns:IsHidden() 
	return true 
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:GetModifierAura()
	return "modifier_dark_ranger_spiked_charm_aura"
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO -- + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_fallen_champion_thorns:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end
