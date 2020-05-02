modifier_treant_take_root_root = class ({})

function modifier_treant_take_root_root:IsHidden()
	return false
end

function modifier_treant_take_root_root:IsPurgable()
	return true
end

function modifier_treant_take_root_root:OnCreated(kv)	
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

	if IsServer() then
		self:StartIntervalThink(1)
	end
end
 
function modifier_treant_take_root_root:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines_small.vpcf"	
end

function modifier_treant_take_root_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_treant_take_root_root:OnIntervalThink()
	if IsServer() then
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage_per_second })
	end
end

function modifier_treant_take_root_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end