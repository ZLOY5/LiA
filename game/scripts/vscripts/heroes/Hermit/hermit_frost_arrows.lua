hermit_frost_arrows = class ({})
LinkLuaModifier("modifier_hermit_frost_arrows","heroes/Hermit/modifier_hermit_frost_arrows.lua",LUA_MODIFIER_MOTION_NONE)

function hermit_frost_arrows:GetManaCost( hTarget )
	if 	self:GetCaster():HasItemInInventory("item_lia_spherical_staff") then
		return self:GetSpecialValueFor( "ManaCost_Scepter" )
	end

	return self.BaseClass.GetManaCost( self, hTarget )
end

--function hermit_frost_arrows:GetDuration( nLevel )
--	if self:GetCaster():HasItemInInventory("item_lia_spherical_staff") then
--		return self:GetSpecialValueFor( "Duration_Scepter" )
--	end
-- 
--	return self.BaseClass.GetDuration( self, nLevel )
--end

function hermit_frost_arrows:GetDamage( nLevel )
	if self:GetCaster():HasItemInInventory("item_lia_spherical_staff") then
		return self:GetSpecialValueFor( "Damage_Scepter" )
	end
 
	return self.BaseClass.GetDamage( self, nLevel )
end

function hermit_frost_arrows:OnSpellStart()
	local hCaster = self:GetCaster()
	
	if hCaster == nil then
		return
	end
	
	--hCaster:AddNewModifier(hCaster, self, "modifier_hermit_frost_arrows", { duration = 0.03 })
	
	--

	--EmitSoundOnLocationWithCaster( hCaster:GetOrigin(), "Hero_Nightstalker.Darkness", hCaster )

end