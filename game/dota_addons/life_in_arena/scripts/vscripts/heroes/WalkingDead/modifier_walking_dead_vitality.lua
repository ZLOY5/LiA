
modifier_walking_dead_vitality = class({})

function modifier_walking_dead_vitality:IsHidden()
	return false
end

function modifier_walking_dead_vitality:IsPurgable()
	return false
end

function modifier_walking_dead_vitality:OnCreated(kv)
	self.ability = self:GetAbility()
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.health_regen_per_charge = self:GetAbility():GetSpecialValueFor("health_regen_per_charge")
	self.charge_duration = self:GetAbility():GetSpecialValueFor("charge_duration")
	self.charges = 0
	self.delayed_charges = 0
end

function modifier_walking_dead_vitality:OnRefresh(kv)
	self.incoming_damage_percentage = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.health_regen_per_charge = self:GetAbility():GetSpecialValueFor("health_regen_per_charge")
end

function modifier_walking_dead_vitality:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_walking_dead_vitality:GetModifierIncomingPhysicalDamage_Percentage()
	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return self.incoming_damage_percentage
end

function modifier_walking_dead_vitality:OnDeath(params)
	if IsServer() then
		if params.attacker == self:GetParent() and params.attacker:GetTeam() ~= params.unit:GetTeam() and not self:GetParent():IsIllusion() and not params.unit:IsIllusion() then
			if self:GetParent():PassivesDisabled() then
				return
			end
			

			if self:GetParent():HasModifier("modifier_walking_dead_decay_self") then
				self.delayed_charges = self.delayed_charges + 1
			else
				self.charges = self.charges + 1
				self:SetStackCount(self.charges)
				Timers:CreateTimer({
		            useGameTime = false,
		            endTime = self.charge_duration,
		            callback = function()
						self.charges = self.charges - 1
						self:SetStackCount(self.charges)
		            end
		          })
			end
			
		end
	end
end

function modifier_walking_dead_vitality:GetModifierConstantHealthRegen()
	return self.health_regen_per_charge * self:GetStackCount()
end

function modifier_walking_dead_vitality:ReleaseDelayedCharges()
	local released_charges = self.delayed_charges
	self.delayed_charges = 0
	self.charges = self.charges + released_charges
	self:SetStackCount(self.charges)
	Timers:CreateTimer({
        useGameTime = false,
        endTime = self.charge_duration,
        callback = function()
			self.charges = self.charges - released_charges
			self:SetStackCount(self.charges)
        end
      })
end