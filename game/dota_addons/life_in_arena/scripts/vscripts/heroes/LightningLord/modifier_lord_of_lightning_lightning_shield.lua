modifier_lord_of_lightning_lightning_shield = class({})

function modifier_lord_of_lightning_lightning_shield:IsDebuff()
	return self.isDebuff
end

function modifier_lord_of_lightning_lightning_shield:GetEffectName()
	return "particles/lightning_shield.vpcf"
end

function modifier_lord_of_lightning_lightning_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_lord_of_lightning_lightning_shield:OnCreated(kv)
	self.isDebuff = self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()

	if IsServer() then
		self.tick = self:GetAbility():GetSpecialValueFor("think_interval")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		local special = self:GetCaster():HasScepter() and "damage_per_second_scepter" or "damage_per_second"
		self.damage = self:GetAbility():GetSpecialValueFor(special) * self.tick

		self:StartIntervalThink(self.tick)
	end

end


function modifier_lord_of_lightning_lightning_shield:OnIntervalThink()
	local target = self:GetParent()
	local caster = self:GetCaster()
	
	local nearby_units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)

	local damage_table = { attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }
	
	for _, nUnit in pairs(nearby_units) do
		if target ~= nUnit then  
			damage_table.victim = nUnit
			ApplyDamage(damage_table)
			
			ParticleManager:CreateParticle("particles/lightning_shield_hit.vpcf", PATTACH_ABSORIGIN, nUnit)
		end
	end

end