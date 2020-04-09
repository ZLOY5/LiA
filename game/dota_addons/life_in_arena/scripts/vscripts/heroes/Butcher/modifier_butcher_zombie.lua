modifier_butcher_zombie = class ({})

function modifier_butcher_zombie:IsHidden()
	return false
end

function modifier_butcher_zombie:IsPurgable()
	return false
end

function modifier_butcher_zombie:DestroyOnExpire()
	return false
end

function modifier_butcher_zombie:OnCreated(kv)
	if IsServer() then
		self.zombie_limit = self:GetAbility():GetSpecialValueFor("zombie_limit")
		self.zombie_replenish_time = self:GetAbility():GetSpecialValueFor("zombie_replenish_time")
		self.health_precent_for_zombie = self:GetAbility():GetSpecialValueFor("health_precent_for_zombie") * 0.01
		self.damage_needed = self:GetParent():GetMaxHealth() * self.health_precent_for_zombie 
		self.damage_taken = 0
		self.damage_left = self.damage_needed - self.damage_taken
		self:SetStackCount(0)
		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { zombie_damage_left = self.damage_left } )
	--[[	if IsServer() then
			self:SetDuration(self.zombie_replenish_time, true)
			Timers:CreateTimer("ButcherZombie",
				{
					endTime = self.zombie_replenish_time,
					callback = function()  
						if self:GetStackCount() < self.zombie_limit then
							self:IncrementStackCount()
						end
						self:SetDuration(self.zombie_replenish_time,true) 
						return self.zombie_replenish_time 
					end
				}
			)
		end]]    -- if stacks from damage are not enough
	end
end

function modifier_butcher_zombie:OnRefresh(kv)
	self.zombie_limit = self:GetAbility():GetSpecialValueFor("zombie_limit")
	self.health_precent_for_zombie = self:GetAbility():GetSpecialValueFor("health_precent_for_zombie") * 0.01
end

function modifier_butcher_zombie:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
 
	return funcs
end

function modifier_butcher_zombie:OnTakeDamage(params)
	if IsServer() then 																
		if not self:GetParent():PassivesDisabled() then						
			if params.unit == self:GetParent() then 							
				if params.unit:GetTeamNumber() ~= params.attacker:GetTeamNumber() then   
					self.damage_taken = self.damage_taken + params.damage	
					self.damage_left = self.damage_needed - self.damage_taken
					CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { zombie_damage_left = self.damage_left } )	
					if self.damage_taken >= self.damage_needed then 							
						if self:GetStackCount() < self.zombie_limit then
							self:IncrementStackCount()
							self.damage_needed = self:GetParent():GetMaxHealth() * self.health_precent_for_zombie 
						end
						self.damage_taken = 0											
					end
				end
			end
		end
	end
end

function modifier_butcher_zombie:OnDeath(params)
	if IsServer() then 
		if params.unit == self:GetParent() and not params.unit:IsIllusion() then
			self:GetAbility():OnSpellStart()
		end
	end
end

function modifier_butcher_zombie:OnTooltip(params)
	local netTable = CustomNetTables:GetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ) )
	return netTable.zombie_damage_left
end

