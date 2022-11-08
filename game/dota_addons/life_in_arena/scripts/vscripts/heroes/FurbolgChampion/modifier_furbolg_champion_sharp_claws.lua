modifier_furbolg_champion_sharp_claws = class({})

function modifier_furbolg_champion_sharp_claws:IsHidden()
	return false
end

function modifier_furbolg_champion_sharp_claws:IsPurgable()
	return false
end

function modifier_furbolg_champion_sharp_claws:OnCreated(kv)
	self.attacks_required = self:GetAbility():GetSpecialValueFor("attacks_required")
	self.damage_per_agility = self:GetAbility():GetSpecialValueFor("damage_per_agility")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.full_stacks = false
end

function modifier_furbolg_champion_sharp_claws:OnRefresh(kv)
	self.attacks_required = self:GetAbility():GetSpecialValueFor("attacks_required")
	self.damage_per_agility = self:GetAbility():GetSpecialValueFor("damage_per_agility")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
end

function modifier_furbolg_champion_sharp_claws:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_furbolg_champion_sharp_claws:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
			if hTarget ~= nil and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				if self:GetStackCount() == self.attacks_required then
					local damage = {
						victim = hTarget,
						attacker = self:GetParent(),
						damage = self:GetParent():GetAgility() * self.damage_per_agility,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility()
					}
		
					ApplyDamage( damage )
					hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
					local particle_cast = "particles/custom/furbolg_champion/furbolg_champion_sharp_claws_bash.vpcf"
					local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, hTarget)
					ParticleManager:SetParticleControl(effect_cast, 1, hTarget:GetOrigin())
					ParticleManager:ReleaseParticleIndex(effect_cast)
					self:SetStackCount(0)
					self.full_stacks = false
					ParticleManager:DestroyParticle(self.hero_effect, true)
					ParticleManager:ReleaseParticleIndex(self.hero_effect)
					hTarget:EmitSound("Hero_TrollWarlord.BerserkersRage.Stun")
				else
					self:IncrementStackCount() 
					if self:GetStackCount() == self.attacks_required then
						local particle_cast = "particles/custom/furbolg_champion/furbolg_champion_sharp_claws_buff.vpcf"
						self.hero_effect = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
						ParticleManager:SetParticleControl(self.hero_effect, 1, self:GetParent():GetOrigin())
						self.full_stacks = true
					end
				end
			end
		end
	end
end
