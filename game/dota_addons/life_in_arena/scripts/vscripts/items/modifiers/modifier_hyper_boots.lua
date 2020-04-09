
modifier_hyper_boots = class({})

--------------------------------------------------------------------------------

function modifier_hyper_boots:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:OnCreated( kv )
	if IsServer() then
		self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
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

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")

		local targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
									self:GetParent():GetAbsOrigin(), 
									nil, self.radius, 
									DOTA_UNIT_TARGET_TEAM_ENEMY, 
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
									0, 0, false)

		for k,v in pairs (targets) do
			ApplyDamage({ victim = v, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
			v:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
		end

		FindClearSpaceForUnit_IgnoreNeverMove(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:GetStatusEffectName()
	return "particles/status_fx/status_effect_forcestaff.vpcf" 
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:GetStatusEffectName()
	return 20
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:GetEffectName()
	return "particles/items_fx/force_staff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

