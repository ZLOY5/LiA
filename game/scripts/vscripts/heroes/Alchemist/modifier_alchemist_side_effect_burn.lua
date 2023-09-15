modifier_alchemist_side_effect_burn = class({})

function modifier_alchemist_side_effect_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alchemist_side_effect_burn:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_burn:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_burn:OnCreated( kv )
	-- self.movement_slow_percent = self:GetAbility():GetSpecialValueFor( "movespeed_slow_percentage" )
	-- self.turn_rate_slow_percentage = self:GetAbility():GetSpecialValueFor( "turn_rate_slow_percentage" )
	self.damage_per_second = kv.damage_per_second

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

-- function modifier_alchemist_side_effect_burn:DeclareFunctions()
-- 	local funcs =
-- 	{
-- 		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
-- 		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
-- 	}
	
-- 	return funcs
-- end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_burn:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_flamebreak_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_burn:OnIntervalThink()
	if IsServer() then

		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage_per_second,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self:GetAbility()
			}

		ApplyDamage( damage )
	end
end

-- --------------------------------------------------------------------------------

-- function modifier_alchemist_side_effect_burn:GetModifierMoveSpeedBonus_Percentage()
-- 	return self.movement_slow_percent
-- end

-- --------------------------------------------------------------------------------

-- function modifier_alchemist_side_effect_burn:GetModifierTurnRate_Percentage()
-- 	return self.turn_rate_slow_percentage
-- end