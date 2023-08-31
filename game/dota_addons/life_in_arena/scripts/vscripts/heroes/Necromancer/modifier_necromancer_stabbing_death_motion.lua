modifier_necromancer_stabbing_death_motion = class({})

--------------------------------------------------------------------------------

local MINIMUM_HEIGHT_ABOVE_LOWEST = 200
local MINIMUM_HEIGHT_ABOVE_HIGHEST = 100
local ACCELERATION_Z = 1500

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:OnCreated( kv )
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self.damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" )
		else
			self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		end

		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "flight_duration" )
		local flDesiredHeight = MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * ACCELERATION_Z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( ACCELERATION_Z ), ( self.flInitialVelocityZ - flSqrtDet) / ( ACCELERATION_Z ) )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
		local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:GetAbility():Splatter()
			end

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_necromancer_stabbing_death_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end