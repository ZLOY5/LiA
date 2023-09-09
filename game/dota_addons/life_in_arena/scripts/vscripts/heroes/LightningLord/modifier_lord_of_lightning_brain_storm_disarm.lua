
modifier_lord_of_lightning_brain_storm_disarm = class({})

function modifier_lord_of_lightning_brain_storm_disarm:IsHidden()
	return false
end

function modifier_lord_of_lightning_brain_storm_disarm:IsPurgable()
	return true
end

function modifier_lord_of_lightning_brain_storm_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_lord_of_lightning_brain_storm_disarm:GetEffectName()
	return "particles/custom/lightning_lord/lightning_lord_brain_storm_disarm.vpcf"
end

function modifier_lord_of_lightning_brain_storm_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end