item_lia_hyper_boots = class({})

LinkLuaModifier("modifier_hyper_boots","items/item_lia_hyper_boots.lua",LUA_MODIFIER_MOTION_HORIZONTAL)

function item_lia_hyper_boots:OnSpellStart()
	if IsServer() then
		self.target = self:GetCursorTarget()
		self.caster = self:GetCaster()

		local kv =
			{
				vLocX = hTarget:GetOrigin().x,
				vLocY = hTarget:GetOrigin().y,
				vLocZ = hTarget:GetOrigin().z
			}

		self.caster:AddNewModifier( self.caster, self, "modifier_hyper_boots", kv )
	end	
end											


modifier_hyper_boots = class({})


--------------------------------------------------------------------------------

function mmodifier_hyper_boots:OnCreated( kv )
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
	end
end

--------------------------------------------------------------------------------

function modifier_hyper_boots:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self.bLaunched ~= true then
			local entities = FindUnitsInRadius( me:GetTeamNumber(), me:GetOrigin(), self:GetCaster(), 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			for _,ent in pairs( entities ) do
				if ent ~= nil and ent:IsNull() == false and self:GetAbility():HasLoadedUnit( ent ) == false and ent ~= self:GetCaster() then
					self:GetAbility():LoadUnit( ent )
				end
			end
		end
		
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end