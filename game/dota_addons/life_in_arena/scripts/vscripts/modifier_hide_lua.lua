modifier_hide_lua = class({})

function modifier_hide_lua:IsHidden()
	return true
end

function modifier_hide_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
 	[MODIFIER_STATE_INVULNERABLE] = true,
 	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
 	[MODIFIER_STATE_UNSELECTABLE] = true,
 	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
 	[MODIFIER_STATE_INVISIBLE] = true,
 	[MODIFIER_STATE_MUTED] = true,
 	[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
	[MODIFIER_STATE_NO_TEAM_SELECT] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
 
	return state
end
