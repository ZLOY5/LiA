modifier_wanderer_arcane_aura_slow = class({})

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:OnCreated( kv )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:OnRefresh( kv )
	self.movement_slow_percentage = self:GetAbility():GetSpecialValueFor( "movement_slow_percentage" )
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:GetEffectName()
	return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_mist.vpcf"
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wanderer_arcane_aura_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percentage
end

--------------------------------------------------------------------------------

