
modifier_keeper_of_the_grove_natures_curse_disarm = class({})

function modifier_keeper_of_the_grove_natures_curse_disarm:IsHidden()
	return false
end

function modifier_keeper_of_the_grove_natures_curse_disarm:IsPurgable()
	return false
end

function modifier_keeper_of_the_grove_natures_curse_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_keeper_of_the_grove_natures_curse_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_keeper_of_the_grove_natures_curse_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end