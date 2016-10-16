modifier_hell_beast_sleep = class({})

function modifier_hell_beast_sleep:IsPurgable()
	return true
end

function modifier_hell_beast_sleep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_TAKEDAMAGE
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

function modifier_hell_beast_sleep:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		self:Destroy()
	end
end


