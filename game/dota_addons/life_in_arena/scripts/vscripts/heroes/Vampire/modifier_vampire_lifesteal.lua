modifier_vampire_lifesteal = class({})

function modifier_vampire_lifesteal:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_vampire_lifesteal:IsHidden()
	return false
end

function modifier_vampire_lifesteal:IsPurgable()
	return false
end

function modifier_vampire_lifesteal:DeclareFunctions()
	local funcs = {
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_TAKEDAMAGE,
					MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_vampire_lifesteal:OnCreated(params)
	self:GetParent().thirst_points = 0
end

function modifier_vampire_lifesteal:OnDeath(params)
	if IsServer() then 
		local parent = self:GetParent()
		if params.attacker == self:GetParent() 
		and not params.unit:IsBuilding() 
		and params.unit:GetTeam() ~= self:GetParent():GetTeam() then 
			if parent.thirst_points < parent.thirst_points_max then
				parent.thirst_points = parent.thirst_points + 1
			end
			self:SetStackCount(parent.thirst_points)
		elseif params.unit == parent then
			parent.thirst_points = 0
			self:SetStackCount(parent.thirst_points)
		end
	end
end

function modifier_vampire_lifesteal:OnAttackLanded(params)
	if IsServer() then 
		if params.attacker == self:GetParent() and not params.target:IsBuilding() and params.target:GetTeam() ~= self:GetParent():GetTeam() then 
			self.lifesteal_record = params.record
		end
	end
end

function modifier_vampire_lifesteal:OnTakeDamage(params)
	if IsServer() then
		if params.record == self.lifesteal_record then
			local parent = self:GetParent()
			local heal_percent = self:GetAbility():GetSpecialValueFor("lifesteal_percentage")*0.01
			local heal = heal_percent*params.damage
			parent:Heal(heal, parent)
			SendOverheadEventMessage(parent:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, parent, heal, nil)
		end
	end
end