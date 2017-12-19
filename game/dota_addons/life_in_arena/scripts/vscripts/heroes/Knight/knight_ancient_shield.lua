knight_ancient_shield = class({})
LinkLuaModifier("modifier_knight_ancient_shield","heroes/Knight/modifier_knight_ancient_shield.lua",LUA_MODIFIER_MOTION_NONE)

function knight_ancient_shield:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_knight_ancient_shield", nil)
	else
		self:GetCaster():RemoveModifierByName("modifier_knight_ancient_shield")
	end
end

--------------------------------------------------------------------------------

function knight_ancient_shield:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() )  then
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = hTarget.fAncientShieldReturnDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return true
end