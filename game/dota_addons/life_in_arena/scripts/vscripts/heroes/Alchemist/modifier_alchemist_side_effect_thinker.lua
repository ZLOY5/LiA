modifier_alchemist_side_effect_thinker = class({})

function modifier_alchemist_side_effect_thinker:IsHidden()
	return false
end

function modifier_alchemist_side_effect_thinker:IsPurgable()
	return false
end

if IsServer() then
	function modifier_alchemist_side_effect_thinker:OnCreated(kv)
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self.sideEffectParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl( self.sideEffectParticle, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.sideEffectParticle, 1, Vector( self.radius, 1, 1 ) )
		self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

		self:StartIntervalThink(1)		
	end


	function modifier_alchemist_side_effect_thinker:OnIntervalThink()
		if IsServer() then
			local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), 
												self:GetParent():GetAbsOrigin(), 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

			for k,v in pairs (targets) do
				ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
			end 

		end
	end
end

function modifier_alchemist_side_effect_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.sideEffectParticle,true)
		self:GetParent():StopSound("Hero_Alchemist.AcidSpray") 
	end
end
