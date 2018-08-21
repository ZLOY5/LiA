hermit_summon_water_elemental = class ({})
LinkLuaModifier("modifier_hermit_summon_water_elemental","heroes/Hermit/modifier_hermit_summon_water_elemental.lua",LUA_MODIFIER_MOTION_NONE)

function hermit_summon_water_elemental:GetManaCost( hTarget )
	if 	self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "ManaCost_Scepter" )
	end

	return self.BaseClass.GetManaCost( self, hTarget )
end

function hermit_summon_water_elemental:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "Cooldown_Scepter" )
	end
 
	return self.BaseClass.GetCooldown( self, nLevel )
end

function hermit_summon_water_elemental:OnSpellStart()
	local hCaster = self:GetCaster()
	
	if hCaster == nil then
		return
	end
	
	hCaster:AddNewModifier(hCaster, self, "modifier_hermit_summon_water_elemental", { duration = 0.10 })
	
	--

	--EmitSoundOnLocationWithCaster( hCaster:GetOrigin(), "Hero_Nightstalker.Darkness", hCaster )

end