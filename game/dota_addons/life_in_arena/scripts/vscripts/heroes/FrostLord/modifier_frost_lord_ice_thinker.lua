modifier_frost_lord_ice_thinker = class({})

function modifier_frost_lord_ice_thinker:IsHidden()
	return true
end

function modifier_frost_lord_ice_thinker:IsPurgable()
	return false
end

function modifier_frost_lord_ice_thinker:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf"
end

function modifier_frost_lord_ice_thinker:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

if IsServer() then

	function modifier_frost_lord_ice_thinker:OnCreated(kv)
		if self:GetCaster():HasScepter() then
			self.damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" )
		else
			self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		end

		self.movement_slow_repcentage = self:GetAbility():GetSpecialValueFor( "movement_slow_repcentage" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )

		self:OnIntervalThink()
		self:StartIntervalThink(1)		
	end


	function modifier_frost_lord_ice_thinker:OnIntervalThink()
		if IsServer() then

			local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), 
												self:GetAbility().vPos, 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

			if #targets > 0 then
				local target = targets[1]
				local affected_units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), 
												targets[1]:GetAbsOrigin(), 
												nil, self.damage_radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

				for k,v in pairs (affected_units) do
					ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
					v:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_frost_lord_ice_debuff", {duration = self.slow_duration})
				end 
				ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_POINT_FOLLOW, target)
				target:EmitSound("Ability.FrostNova")
			end

		end
	end

end