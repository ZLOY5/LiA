modifier_stun_lua = class({})

function modifier_stun_lua:IsHidden()
	return true
end

function modifier_stun_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end
