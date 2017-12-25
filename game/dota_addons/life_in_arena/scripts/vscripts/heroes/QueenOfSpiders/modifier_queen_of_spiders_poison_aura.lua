modifier_queen_of_spiders_poison_aura = class({})

function modifier_queen_of_spiders_poison_aura:IsHidden() 
	return true 
end

function modifier_queen_of_spiders_poison_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetModifierAura()
	return "modifier_queen_of_spiders_poison_effect"
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_queen_of_spiders_poison_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end