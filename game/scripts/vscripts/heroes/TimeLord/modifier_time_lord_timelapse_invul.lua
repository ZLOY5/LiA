modifier_time_lord_timelapse_invul = class({})

function modifier_time_lord_timelapse_invul:IsHidden()
	return true
end

function modifier_time_lord_timelapse_invul:IsPurgable()
	return false
end
 
function modifier_time_lord_timelapse_invul:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true
	}
end
