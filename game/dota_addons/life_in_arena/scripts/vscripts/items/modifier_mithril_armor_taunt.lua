modifier_mithril_armor_taunt = class({})

function modifier_mithril_armor_taunt:IsDebuff()
	return true
end

function modifier_mithril_armor_taunt:IsPurgable()
	return false
end

function modifier_mithril_armor_taunt:GetStatusEffectName()
	return "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf"
end

function modifier_mithril_armor_taunt:StatusEffectPriority()
	return 10
end

function modifier_mithril_armor_taunt:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
 
	return state
end

function modifier_mithril_armor_taunt:OnDestroy()
	if IsServer() then
		self:GetParent():Interrupt()
	end
end