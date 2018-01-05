
modifier_tauren_champion_accumulated_rage = class({})

function modifier_tauren_champion_accumulated_rage:IsHidden()
	return true
end

function modifier_tauren_champion_accumulated_rage:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage:OnCreated(kv)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_accumulated_rage_block", nil)
	end
end

function modifier_tauren_champion_accumulated_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_RESPAWN,
	}
 
	return funcs
end

function modifier_tauren_champion_accumulated_rage:OnRespawn()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_accumulated_rage_block", nil)
	end
end

-------------------------------------------------------------------------------
