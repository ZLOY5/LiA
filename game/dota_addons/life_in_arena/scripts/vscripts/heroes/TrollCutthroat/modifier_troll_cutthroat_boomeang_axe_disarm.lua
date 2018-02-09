
modifier_troll_cutthroat_boomeang_axe_disarm = class({})

function modifier_troll_cutthroat_boomeang_axe_disarm:IsHidden()
	return false
end

function modifier_troll_cutthroat_boomeang_axe_disarm:IsPurgable()
	return false
end

function modifier_troll_cutthroat_boomeang_axe_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_troll_cutthroat_boomeang_axe_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_troll_cutthroat_boomeang_axe_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end