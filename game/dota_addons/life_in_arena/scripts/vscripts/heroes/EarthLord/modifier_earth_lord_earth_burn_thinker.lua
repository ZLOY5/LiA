modifier_earth_lord_earth_burn_thinker = class({})

function modifier_earth_lord_earth_burn_thinker:IsHidden()
	return true
end

function modifier_earth_lord_earth_burn_thinker:IsPurgable()
	return false
end

if IsServer() then

	function modifier_earth_lord_earth_burn_thinker:OnCreated(kv)
		local caster = self:GetCaster()
		if caster:HasScepter() then
			self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second_scepter" )
		else
			self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		end

		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self.earthBurnParticle = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_edge.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl( self.earthBurnParticle, 0, self:GetAbility().vPos )
		ParticleManager:SetParticleControl( self.earthBurnParticle, 1, Vector( self.radius, 1, 1 ) )
		self:GetParent():EmitSound("Hero_Warlock.Upheaval")

		self:StartIntervalThink(1)		
	end


	function modifier_earth_lord_earth_burn_thinker:OnIntervalThink()
		if IsServer() then

			local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), 
												self:GetAbility().vPos, 
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

	function modifier_earth_lord_earth_burn_thinker:OnDestroy()
		ParticleManager:DestroyParticle(self.earthBurnParticle,true)
		self:GetParent():StopSound("Hero_Warlock.Upheaval") 
	end

end