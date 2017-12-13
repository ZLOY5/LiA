tauren_champion_finish_off = class({})
LinkLuaModifier("modifier_tauren_champion_finish_off","heroes/TaurenChampion/tauren_champion_finish_off.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_finish_off_counter","heroes/TaurenChampion/tauren_champion_finish_off.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_finish_off:GetIntrinsicModifierName()
	return "modifier_tauren_champion_finish_off"
end

-------------------------------------------------------------------------------

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
		MODIFIER_EVENT_ON_ATTACK_FAIL,
	}
 
	return funcs
end

function modifier_tauren_champion_finish_off:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self:GetParent():PassivesDisabled() then
				return
			end

			if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local modifier_counter = params.target:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", self:GetParent())
				if not modifier_counter then
					params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_finish_off_counter", {duration = self.duration})
					params.target:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", self:GetParent()):SetStackCount(1)
				else
					if modifier_counter:GetStackCount() < self.attack_count - 1 then
						modifier_counter:IncrementStackCount()
						modifier_counter:SetDuration("duration", true)
					else 
						if self.bIsCrit == true then

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

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if hTarget:FindModifierByNameAndCaster("modifier_tauren_champion_finish_off_counter", self:GetParent()):GetStackCount() == self.attack_count - 1 then 
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

-------------------------------------------------------------------------------

modifier_tauren_champion_finish_off_counter = class({})

function modifier_tauren_champion_finish_off_counter:IsHidden()
	return false
end

function modifier_tauren_champion_finish_off_counter:IsPurgable()
	return true
end




