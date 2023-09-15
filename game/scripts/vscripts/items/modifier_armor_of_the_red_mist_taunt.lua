modifier_armor_of_the_red_mist_taunt = class({})

function modifier_armor_of_the_red_mist_taunt:IsDebuff()
	return true
end

function modifier_armor_of_the_red_mist_taunt:IsPurgable()
	return false
end

function modifier_armor_of_the_red_mist_taunt:GetStatusEffectName()
	return "particles/custom/items/armor_of_the_red_mist_effect.vpcf"
end

function modifier_armor_of_the_red_mist_taunt:StatusEffectPriority()
	return 10
end

function modifier_armor_of_the_red_mist_taunt:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
 
	return state
end

function modifier_armor_of_the_red_mist_taunt:OnDestroy()
	if IsServer() then
		self:GetParent():Interrupt()
	end
end