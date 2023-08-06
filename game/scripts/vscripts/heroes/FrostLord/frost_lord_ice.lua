frost_lord_ice = class({})
LinkLuaModifier("modifier_frost_lord_ice_thinker","heroes/FrostLord/modifier_frost_lord_ice_thinker.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_lord_ice_debuff","heroes/FrostLord/modifier_frost_lord_ice_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function frost_lord_ice:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function frost_lord_ice:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasScepter() then
				self.duration = self:GetSpecialValueFor( "duration_scepter" )
			else
				self.duration = self:GetSpecialValueFor( "duration" )
			end

		self.vPos = self:GetCursorPosition()

		CreateModifierThinker(
				self:GetCaster(),
				self,
				"modifier_frost_lord_ice_thinker",
				{ 
					duration = self.duration
				},
				self.vPos,
				self:GetCaster():GetTeamNumber(),
				false
			)

		EmitSoundOn( "Hero_Ancient_Apparition.IceVortexCast", self:GetCaster() )
	end
end
