
modifier_hyper_boots = class({})


--------------------------------------------------------------------------------

function modifier_hyper_boots:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		FindClearSpaceForUnit_IgnoreNeverMove(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end