item_lia_hyper_boots = class({})

LinkLuaModifier("modifier_hyper_boots","items/modifiers/item_lia_hyper_boots.lua",LUA_MODIFIER_MOTION_HORIZONTAL)

function item_lia_hyper_boots:OnSpellStart()
	if IsServer() then
		self.target = self:GetCursorTarget()
		self.caster = self:GetCaster()
		self.speed = self:GetSpecialValueFor("charge_speed")

		self.ProjectileInfo =
		{
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			bDodgeable = false,
			iMoveSpeed = self.speed,
		}

		ProjectileManager:CreateTrackingProjectile( self.ProjectileInfo )

		local kv =
			{
				vLocX = self.target:GetOrigin().x,
				vLocY = self.target:GetOrigin().y,
				vLocZ = self.target:GetOrigin().z
			}

		self.caster:AddNewModifier( self.caster, self, "modifier_hyper_boots", kv )
	end	
end		

function item_lia_hyper_boots:OnProjectileThink( vLocation )
	if IsServer() then
		self.vProjectileLocation = vLocation
	end
end		

function item_lia_hyper_boots:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_hyper_boots")
	end

	return false
end							
