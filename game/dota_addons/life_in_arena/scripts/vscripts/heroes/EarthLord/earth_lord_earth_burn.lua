earth_lord_earth_burn = class({})
LinkLuaModifier("modifier_earth_lord_earth_burn_thinker","heroes/EarthLord/modifier_earth_lord_earth_burn_thinker.lua",LUA_MODIFIER_MOTION_NONE)

function earth_lord_earth_burn:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function earth_lord_earth_burn:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function earth_lord_earth_burn:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "duration" )

		self.vPos = self:GetCursorPosition()
		CreateModifierThinker(
				self:GetCaster(),
				self,
				"modifier_earth_lord_earth_burn_thinker",
				{ 
					duration = self.duration
				},
				self.vPos,
				self:GetCaster():GetTeamNumber(),
				false
			)
	end
end
