modifier_necromancer_reincarnation = class({})

function modifier_necromancer_reincarnation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
	}
 
	return funcs
end

function modifier_necromancer_reincarnation:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_necromancer_reincarnation:IsHidden()
	return true 
end

function modifier_necromancer_reincarnation:IsPurgable()
	return false
end

function modifier_necromancer_reincarnation:OnCreated(kv)
	self.reincarnateTime = self:GetAbility():GetSpecialValueFor("reincarnate_time")
end

function modifier_necromancer_reincarnation:ReincarnateTime(params)
	--print("ReincarnateTime")
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1))

		local parent = self:GetParent()
		local respawnPosition = parent:GetAbsOrigin()

		local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
		parent.ReincarnateParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControl(parent.ReincarnateParticle, 0, respawnPosition)
		ParticleManager:SetParticleControl(parent.ReincarnateParticle, 1, Vector(500,0,0))
		ParticleManager:SetParticleControl(parent.ReincarnateParticle, 1, Vector(500,500,0))

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_bits.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, parent )
		ParticleManager:SetParticleControl(particle1, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust.vpcf"
		local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControl(particle2, 0, respawnPosition)

		local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust_reincarnate.vpcf"
		local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControl(particle3 , 0, respawnPosition)

		parent:EmitSound("Hero_SkeletonKing.Reincarnate")
		parent:EmitSound("Hero_SkeletonKing.Death")

		Timers:CreateTimer(self.reincarnateTime,
			function() 
				ParticleManager:DestroyParticle(parent.ReincarnateParticle, false)
				parent:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")

				if not parent:IsAlive() then
					parent:RespawnHero(false, false, false)
				end
			end
		)
		return self.reincarnateTime
	end
	return
end