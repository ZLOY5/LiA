modifier_skeleton_thief_obsession = class({})

function modifier_skeleton_thief_obsession:IsHidden()
	return false
end

function modifier_skeleton_thief_obsession:IsPurgable()
	return false
end

function modifier_skeleton_thief_obsession:OnCreated(kv)
	self.attacks_required = self:GetAbility():GetSpecialValueFor("attacks_required")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_skeleton_thief_obsession:OnRefresh(kv)
	self.attacks_required = self:GetAbility():GetSpecialValueFor("attacks_required")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_skeleton_thief_obsession:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end

function modifier_skeleton_thief_obsession:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
			if hTarget ~= nil and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				if self:GetStackCount() == self.attacks_required then
					self:SetStackCount(0)
					ParticleManager:DestroyParticle(self.hero_effect, true)
					ParticleManager:ReleaseParticleIndex(self.hero_effect)
				else
					self:IncrementStackCount() 
					if self:GetStackCount() == self.attacks_required then
						local particle_cast = "particles/custom/thief_king/thief_king_obsession.vpcf"
						self.hero_effect = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
						ParticleManager:SetParticleControlEnt(self.hero_effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
						self.full_stacks = true
					end
				end
			end
		end
	end
end

function modifier_skeleton_thief_obsession:GetModifierPreAttack_BonusDamage()
	if self:GetStackCount() == self.attacks_required then
		return self.bonus_damage
	end
	return 0
end
