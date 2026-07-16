modifier_alchemist_swiftness_potion_enemy = class({})


function modifier_alchemist_swiftness_potion_enemy:IsHidden()
	return true
end

function modifier_alchemist_swiftness_potion_enemy:IsPurgable()
	return false
end

function modifier_alchemist_swiftness_potion_enemy:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.unit = self:GetParent()
		self:StartIntervalThink( 0.03 )
		self.duration = kv.duration
		self.distance_per_tick = kv.knockback_distance / self.duration
		self.caster_position_x = kv.center_x
		self.caster_position_y = kv.center_y
		self.unit_origin = self.unit:GetAbsOrigin()
		self.unit_position_x = self.unit_origin.x
		self.unit_position_y = self.unit_origin.y
		local vDirection = Vector(self.unit_position_x - kv.center_x, self.unit_position_y - kv.center_y, 0)
		if vDirection:Length2D() < 1 then
			local vForward = self.unit:GetForwardVector()
			vDirection = Vector(-vForward.x, -vForward.y, 0)
		end
		vDirection = vDirection:Normalized()
		self.target = Vector(self.unit_position_x, self.unit_position_y, kv.center_z) + vDirection * kv.knockback_distance
		self.old_position = self.unit_origin
	end
end

function modifier_alchemist_swiftness_potion_enemy:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_alchemist_swiftness_potion_enemy:OnIntervalThink()
	if IsServer() then
		local position = self.unit:GetAbsOrigin()
		local distance = (position - self.target):Length2D()
		local direction = (self.target - position):Normalized()
		local delta = (distance * 1.0 / self.duration) * 1.0 / 30.0
		local next_position = position + direction * delta

		if GridNav:IsBlocked(next_position) or not GridNav:IsTraversable(next_position) then
			self.unit:SetAbsOrigin(self.old_position)
		    self:Destroy()
		else
			self.old_position = self.unit:GetAbsOrigin()
		    self.unit:SetAbsOrigin(next_position)
		end


	end
end

function modifier_alchemist_swiftness_potion_enemy:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.unit, self.unit:GetAbsOrigin(), true)
		self.unit:AddNewModifier(self.caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(self.unit:GetAbsOrigin(),65)
	end
end

function modifier_alchemist_swiftness_potion_enemy:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end