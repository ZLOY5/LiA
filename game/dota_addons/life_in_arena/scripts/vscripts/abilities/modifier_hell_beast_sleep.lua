modifier_hell_beast_sleep = class({})

function modifier_hell_beast_sleep:IsPurgable()
	return true
end

function modifier_hell_beast_sleep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
 
	return funcs
end

function modifier_hell_beast_sleep:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end

function modifier_hell_beast_sleep:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_hell_beast_sleep:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_hell_beast_sleep:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
