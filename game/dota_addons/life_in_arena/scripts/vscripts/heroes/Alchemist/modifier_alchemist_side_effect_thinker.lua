modifier_alchemist_side_effect_thinker = class({})

function modifier_alchemist_side_effect_thinker:IsHidden()
	return false
end

function modifier_alchemist_side_effect_thinker:IsPurgable()
	return false
end


function modifier_alchemist_side_effect_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_thinker:GetModifierAura()
	return "modifier_alchemist_side_effect_debuff"
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_alchemist_side_effect_thinker:GetAuraRadius()
	return self.radius
end

if IsServer() then
	function modifier_alchemist_side_effect_thinker:OnCreated(kv)
		self.caster = self:GetAbility():GetCaster()
		
		self.bIsSideEffectThinker = true
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.burn_duration = self:GetAbility():GetSpecialValueFor( "burn_duration" )

		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self.sideEffectParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl( self.sideEffectParticle, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.sideEffectParticle, 1, Vector( self.radius, 1, 1 ) )
		self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

		self:StartIntervalThink(1)		
	end


	function modifier_alchemist_side_effect_thinker:OnIntervalThink()
		if IsServer() then
			local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
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

function modifier_alchemist_side_effect_thinker:SideEffectExplosion()
	if IsServer() then
		self.fBaseStrengthDamage = self.caster:GetBaseStrength() * self:GetAbility():GetSpecialValueFor( "base_strength_burn_damage_percentage" ) * 0.01
		self.fBonusIntelligenceDamage = (self.caster:GetIntellect() - self.caster:GetBaseIntellect()) * self:GetAbility():GetSpecialValueFor( "bonus_intelligence_explosion_damage_percentage" ) * 0.01

		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self:GetParent():GetAbsOrigin(), 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
												FIND_ANY_ORDER, 
												false)

		for k,v in pairs (targets) do
			ApplyDamage({ victim = v, attacker = self.caster, damage = self.fBaseStrengthDamage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
				v:AddNewModifier( self.caster, self:GetAbility(), "modifier_stunned", {duration = self.stun_duration} )
				v:AddNewModifier( self.caster, self:GetAbility(), "modifier_alchemist_side_effect_burn", {duration = self.burn_duration, damage_per_second = self.fBaseStrengthDamage } )
		end 

		self.sideEffectExplosionParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf",PATTACH_WORLDORIGIN,self:GetParent())
		ParticleManager:SetParticleControl( self.sideEffectExplosionParticle, 3, self:GetParent():GetAbsOrigin() )
		self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

		self:GetParent():ForceKill(false)
		self:Destroy()
	end
end