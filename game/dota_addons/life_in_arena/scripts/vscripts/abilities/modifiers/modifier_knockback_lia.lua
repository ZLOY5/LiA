modifier_knockback_lia = class({})


function modifier_knockback_lia:IsHidden()
	return true
end

function modifier_knockback_lia:IsPurgable()
	return false
end

function modifier_knockback_lia:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.unit = self:GetParent()
		self:StartIntervalThink( 0.03 )
		self.target = self.ability.target_point
		self.distance_per_tick = self.ability.distance_per_tick
		self.duration = kv.duration
	end
end

function modifier_knockback_lia:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_knockback_lia:OnIntervalThink()
	if IsServer() then
		local distance = (self.unit:GetAbsOrigin() - self.target):Length2D()
		local direction = (self.target - self.unit:GetAbsOrigin()):Normalized()
		local delta = (distance * 1.0 / self.duration) * 1.0 / 30.0

		self.unit:SetAbsOrigin(self.unit:GetAbsOrigin() + direction * delta)
	end
end

function modifier_knockback_lia:OnDestroy()
	if IsServer() then
		self.unit:AddNewModifier(self.caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(self.unit:GetAbsOrigin(),65)
	end
end

function modifier_knockback_lia:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end