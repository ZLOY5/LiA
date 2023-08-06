modifier_walking_dead_decay_debuff = class({})

function modifier_walking_dead_decay_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:OnCreated( kv )
	self.movement_slow_percent = self:GetAbility():GetSpecialValueFor( "movespeed_slow_percentage" )
end

--------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:GetEffectName()
	return "particles/custom/walking_dead/walking_dead_decay_recipient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- --------------------------------------------------------------------------------

function modifier_walking_dead_decay_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_percent
end
