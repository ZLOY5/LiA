modifier_walking_dead_rot_curse_enemy = class({})

function modifier_walking_dead_rot_curse_enemy:IsHidden()
	return false
end

function modifier_walking_dead_rot_curse_enemy:IsPurgable()
	return true
end

function modifier_walking_dead_rot_curse_enemy:GetEffectName()
	return "particles/custom/walking_dead/walking_dead_rot_curse_overhead_model.vpcf"	
end

function modifier_walking_dead_rot_curse_enemy:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

if IsServer() then
	function modifier_walking_dead_rot_curse_enemy:OnCreated(kv)
		self.caster = self:GetAbility():GetCaster()
		self.unit = self:GetParent()

		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.health_steal_per_second = self:GetAbility():GetSpecialValueFor( "health_steal_per_second" )
		self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self.break_distance = self:GetAbility():GetSpecialValueFor( "break_distance" )

		
		self.unit:EmitSound("Hero_Undying.Decay.Cast")
		self:StartIntervalThink(self.tick_interval)		
	end


	function modifier_walking_dead_rot_curse_enemy:OnIntervalThink()
		if IsServer() then
			if (self.caster:GetAbsOrigin() - self.unit:GetAbsOrigin()):Length2D() >= self.break_distance then
				self:Destroy()
			end

			local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self:GetParent():GetAbsOrigin(), 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

			for k,v in pairs (targets) do
				if v == self:GetParent() then
					ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.health_steal_per_second, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
				else
					ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
				end

				self.caster:Heal(self.health_steal_per_second, self.caster)
				
			end 
			self.rotCurseAoEParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
			ParticleManager:SetParticleControl( self.rotCurseAoEParticle, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( self.rotCurseAoEParticle, 1, Vector( self.radius, 1, 1 ) )
			self.unit:EmitSound("Hero_Undying.Decay.Target")

			self.rotCurseLinkParticle = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.rotCurseLinkParticle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.rotCurseLinkParticle, 1, self.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.unit:GetOrigin(), true )
			self:AddParticle( self.rotCurseLinkParticle , true, false, 0, false, false )	
		end
	end
end

function modifier_walking_dead_rot_curse_enemy:OnDestroy()
	if IsServer() then
		-- ParticleManager:DestroyParticle(self.sideEffectParticle,true)
		-- self:GetParent():StopSound("Hero_Alchemist.AcidSpray") 
	end
end

