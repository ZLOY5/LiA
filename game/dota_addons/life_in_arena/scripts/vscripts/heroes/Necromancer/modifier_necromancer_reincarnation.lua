modifier_necromancer_reincarnation = class({})

function modifier_necromancer_reincarnation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
	}
 
	return funcs
end

function modifier_necromancer_reincarnation:IsHidden()
	return true 
end

function modifier_necromancer_reincarnation:OnCreated(kv)
	self.reincarnateTime = self:GetAbility():GetSpecialValueFor("reincarnate_time")
end

function modifier_necromancer_reincarnation:ReincarnateTime(params)
	--print("ReincarnateTime")
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1))
		
		Timers:CreateTimer(self.reincarnateTime,
			function() 
				ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN, self:GetParent())
				self:GetParent():RespawnHero(false, true, true)
			end
		)
		return self.reincarnateTime
	end
	return
end