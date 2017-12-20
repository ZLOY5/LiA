modifier_frost_lord_freezing_debuff = class({})

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing_debuff:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_frost_lord_freezing_debuff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
