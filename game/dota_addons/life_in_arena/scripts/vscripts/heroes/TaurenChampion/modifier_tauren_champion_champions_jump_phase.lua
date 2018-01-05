modifier_tauren_champion_champions_jump_phase = class({})

--------------------------------------------------------------------------------

function modifier_tauren_champion_champions_jump_phase:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_tauren_champion_champions_jump_phase:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tauren_champion_champions_jump_phase:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.1,function()
			self:GetParent():SetNeverMoveToClearSpace(false) 
			ResolveNPCPositions(self:GetParent():GetAbsOrigin(),128) 
			self:GetParent():SetNeverMoveToClearSpace(true)
			self:Destroy()
		end)
		
	end
end

--------------------------------------------------------------------------------

function modifier_tauren_champion_champions_jump_phase:OnDestroy()
	if IsServer() then
		
	end
end

