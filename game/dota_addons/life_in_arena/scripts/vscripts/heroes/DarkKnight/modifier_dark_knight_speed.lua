modifier_dark_knight_speed = class ({})

function modifier_dark_knight_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_dark_knight_speed:IsHidden()
	--print(self:GetStackCount())
	if self:GetStackCount() == 0 then
		return true
	end
	return false
end

function modifier_dark_knight_speed:OnCreated( params )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.attack_speed_per_attack = self:GetAbility():GetSpecialValueFor("attack_speed_per_attack")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.max_attack_speed = self:GetAbility():GetSpecialValueFor("max_attack_speed")

	self.attackspeedStack = 0
end

function modifier_dark_knight_speed:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetStackCount() + self.bonus_attack_speed
end

function modifier_dark_knight_speed:IsPurgable()
	return false
end

function modifier_dark_knight_speed:OnRefresh( params )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_dark_knight_speed:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() and params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber() then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
 			
			local attack_speed_per_attack = self.attack_speed_per_attack
				
			self.attackspeedStack = self.attackspeedStack + attack_speed_per_attack
			
			if self.attackspeedStack < self.max_attack_speed then --для того чтобы удары, которые герой получил после превышения лимита учитывались, но лимит не превышался
				self:SetStackCount(self.attackspeedStack)
			else 
				self:SetStackCount(self.max_attack_speed)
			end
				
			Timers:CreateTimer(self.duration,
				function()
					self.attackspeedStack = self.attackspeedStack - attack_speed_per_attack
					
					if self.attackspeedStack < self.max_attack_speed then
						self:SetStackCount(self.attackspeedStack)
					else 
						self:SetStackCount(self.max_attack_speed)
					end
				end
			)
		end
	end
end