modifier_treant_sharp_thorns_debuff = class({})

function modifier_treant_sharp_thorns_debuff:IsHidden()
	return false
end

function modifier_treant_sharp_thorns_debuff:IsPurgable()
	return true
end

function modifier_treant_sharp_thorns_debuff:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.unit = self:GetParent()
		self.check_interval = self.ability:GetSpecialValueFor("check_interval")
		self.distance_to_damage = self.ability:GetSpecialValueFor("distance_to_damage_percentage") * 0.01
		self:StartIntervalThink( self.check_interval )
		self.old_position = self.unit:GetAbsOrigin()
		self.particle = ParticleManager:CreateParticle("particles/custom/treant/treant_sharp_thorns_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.unit)
		ParticleManager:SetParticleControlEnt(self.particle, 1, self.unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.unit:GetAbsOrigin(), true)
	end
end

function modifier_treant_sharp_thorns_debuff:OnIntervalThink()
	if IsServer() then
		self.new_position = self.unit:GetAbsOrigin()
		local distance = (self.old_position - self.new_position):Length2D()
		local damage = distance * self.distance_to_damage

		ApplyDamage({ victim = self.unit, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_PURE, damage = damage })
		self.old_position = self.new_position
	end
end


function modifier_treant_sharp_thorns_debuff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
	end
end