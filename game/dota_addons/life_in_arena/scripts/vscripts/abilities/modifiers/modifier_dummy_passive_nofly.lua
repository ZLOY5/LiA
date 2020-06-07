modifier_dummy_passive_nofly = class({})

--------------------------------------------------------------------------------

function modifier_dummy_passive_nofly:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dummy_passive_nofly:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dummy_passive_nofly:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

