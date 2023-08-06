modifier_ghoul_persistence = class({})

function modifier_ghoul_persistence:IsHidden()
	return true
end

function modifier_ghoul_persistence:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetModifierAura()
	return "modifier_ghoul_persistence_effect"
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetAuraRadius()
	return self:GetParent():IsIllusion() and 1 or self.aura_radius 
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
end

--------------------------------------------------------------------------------

function modifier_ghoul_persistence:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end

function modifier_ghoul_persistence:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end