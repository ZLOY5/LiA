modifier_treant_craving_for_nature_movement = class({})

function modifier_treant_craving_for_nature_movement:IsHidden()
	return true
end

function modifier_treant_craving_for_nature_movement:IsPurgable()
	return false
end

function modifier_treant_craving_for_nature_movement:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.unit = self:GetParent()
		self:StartIntervalThink( self.ability.tick_time )
		self.target = self.ability.target_point
		self.distance_per_tick = self.ability.distance_per_tick
		self.duration = kv.duration
	end
end

function modifier_treant_craving_for_nature_movement:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_treant_craving_for_nature_movement:OnIntervalThink()
	if IsServer() then
		local distance = (self.unit:GetAbsOrigin() - self.target):Length2D()
		local direction = (self.target - self.unit:GetAbsOrigin()):Normalized()
		local delta = (distance * 1.0 / self.duration) * 1.0 / 30.0

		self.unit:SetAbsOrigin(self.unit:GetAbsOrigin() + direction * delta)
	end
end

function modifier_treant_craving_for_nature_movement:OnDestroy()
	if IsServer() then
		self.damage = self.ability:GetSpecialValueFor("damage")
		if self.unit:HasModifier("modifier_treant_take_root_root") then
			self.damage = self.damage * self.ability:GetSpecialValueFor("root_damage_multiplier")
		end

		ApplyDamage({ victim = self.unit, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage })
		
		self.unit:AddNewModifier(self.caster, nil, "modifier_phased", { duration = 0.03 })
		ResolveNPCPositions(self.unit:GetAbsOrigin(),65)
	end
end

function modifier_treant_craving_for_nature_movement:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end