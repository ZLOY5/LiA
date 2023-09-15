modifier_tauren_champion_finish_off = class({})

function modifier_tauren_champion_finish_off:IsHidden()
	return true
end

function modifier_tauren_champion_finish_off:IsPurgable()
	return false
end

function modifier_tauren_champion_finish_off:OnCreated(kv)
	self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.bIsCrit = false
end

function modifier_tauren_champion_finish_off:OnRefresh(kv)
	self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_tauren_champion_finish_off:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_tauren_champion_finish_off:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			local hTarget = params.target
			if hTarget ~= nil and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local modifier_counter = hTarget:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", self:GetParent())
				if not modifier_counter then
					hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_finish_off_counter", {duration = self.duration})
					hTarget:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", self:GetParent()):SetStackCount(1)
					hTarget.finishOffCounter = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack_number.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
					ParticleManager:SetParticleControl(hTarget.finishOffCounter, 1, Vector(0,1,0))
				else
					if modifier_counter:GetStackCount() < self.attack_count - 1 then
						modifier_counter:IncrementStackCount()
						modifier_counter:SetDuration(self.duration, true)
						ParticleManager:SetParticleControl(hTarget.finishOffCounter, 1, Vector(0,modifier_counter:GetStackCount(),0))
					else 
						if self.bIsCrit == true then
							ParticleManager:DestroyParticle(hTarget.finishOffCounter, true)
							EmitSoundOn("Hero_EarthShaker.Totem.Attack.Immortal", hTarget)
							hTarget:RemoveModifierByName("modifier_tauren_champion_finish_off_counter")
							self.bIsCrit = false
						end
					end
				end
			end
		end
	end
end


function modifier_tauren_champion_finish_off:OnAttackFail( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self.bIsCrit = false
		end
	end
end

function modifier_tauren_champion_finish_off:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) and hAttacker == self:GetParent() then
			local modifier = hTarget:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", hAttacker)
			if modifier then
				if modifier:GetStackCount() == self.attack_count - 1 then 
					self.bIsCrit = true
					hAttacker:AddNewModifier(hAttacker, self:GetAbility(), "modifier_tauren_champion_finish_off_animation", nil)
					return self.crit_multiplier
				end
			end
		end
	end

	return 0.0
end

