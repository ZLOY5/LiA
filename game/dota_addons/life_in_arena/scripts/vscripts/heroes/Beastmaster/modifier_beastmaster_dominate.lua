modifier_beastmaster_dominate = class({})

function modifier_beastmaster_dominate:IsHidden()
	return false 
end

function modifier_beastmaster_dominate:IsPurgable()
	return false 
end

function modifier_beastmaster_dominate:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.owner = self.parent:GetOwner()
		self.team = self.parent:GetTeam()
		if self.owner == nil then
			self.playerID = -1
		else
			self.playerID = self.parent:GetPlayerID()
		end
		self.parent:SetOwner(self.caster)
		self.parent:SetTeam(self.caster:GetTeam())
		self.parent:SetControllableByPlayer(self.caster:GetPlayerID(), false)
		self.parent:Purge(true, true, false, true, false)
	end
end

function modifier_beastmaster_dominate:OnDestroy()
	if IsServer() then
		if self.parent:IsAlive() then
			self.parent:SetOwner(self.owner)
			self.parent:SetTeam(self.team)
			self.parent:SetControllableByPlayer(self.playerID, false)
			self.parent:Purge(true, true, false, true, false)
		end
	end
end

function modifier_beastmaster_dominate:CheckState()
	local state = 
	{
		[MODIFIER_STATE_DOMINATED] = true
	}
	return state
end

function modifier_beastmaster_dominate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

function modifier_beastmaster_dominate:OnDeath(params)
	if IsServer() then 
		if params.unit == self.parent and string.find(params.unit:GetUnitName(),"_wave_creep") and Survival.State == SURVIVAL_STATE_ROUND_WAVE then
			local bounty = params.unit:GetGoldBounty()
			Survival:ExperienceDistribute(params.unit)
			self.caster:ModifyGold(bounty, false, DOTA_ModifyGold_CreepKill)
			SendOverheadEventMessage(self.caster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, params.unit, bounty, nil )
			PlayerResource:IncrementCreepKills(self.caster:GetPlayerOwnerID())
        	FightRecap:IncrementCreepKills(self.caster:GetPlayerOwnerID())
		end
	end
end
