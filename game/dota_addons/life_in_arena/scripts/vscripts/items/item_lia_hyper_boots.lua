item_lia_hyper_boots = class({})

LinkLuaModifier("modifier_hyper_boots","items/modifiers/modifier_hyper_boots.lua",LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_hyper_boots_movespeed","items/item_lia_hyper_boots.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_hyper_boots:GetIntrinsicModifierName()
	return "modifier_hyper_boots_movespeed"
end

function item_lia_hyper_boots:CastFilterResultTarget( hTarget )
	local nCasterID = self:GetCaster():GetPlayerOwnerID()
	local nTargetID = hTarget:GetPlayerOwnerID()
	

	if IsServer() then 
		if not hTarget:IsHero() and hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end

		if self:GetCaster() == hTarget then
			return UF_FAIL_CUSTOM
		end
	end

	return UnitFilter(hTarget,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,self:GetCaster():GetTeamNumber())

end

function item_lia_hyper_boots:GetCustomCastErrorTarget( hTarget )
	if IsServer() then 
		if not hTarget:IsHero() and hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return "#cant_target_allied_creeps"
		end

		if self:GetCaster() == hTarget then
			return "#dota_hud_error_cant_cast_on_self"
		end
	end
end

function item_lia_hyper_boots:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		self.speed = self:GetSpecialValueFor("charge_speed")
		self.target = self:GetCursorTarget()

		self.vProjectileLocation = self.caster:GetOrigin()

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

		EmitSoundOn("DOTA_Item.ForceStaff.Activate", self.caster)
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

-------------------------------------------------------------------

modifier_hyper_boots_movespeed = class({})

function modifier_hyper_boots_movespeed:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_hyper_boots_movespeed:IsHidden()
	return false 
end

function modifier_hyper_boots_movespeed:IsPurgable()
	return false 
end

function modifier_hyper_boots_movespeed:OnCreated(kv)
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_hyper_boots_movespeed:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
	}
 
	return funcs
end

function modifier_hyper_boots_movespeed:GetModifierMoveSpeedBonus_Special_Boots()
    return self.bonus_movement_speed
end