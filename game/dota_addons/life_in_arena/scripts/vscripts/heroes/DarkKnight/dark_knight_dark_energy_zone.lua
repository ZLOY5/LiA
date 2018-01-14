dark_knight_dark_energy_zone = class({})
LinkLuaModifier("modifier_dark_knight_dark_energy_zone_effect","heroes/DarkKnight/modifier_dark_knight_dark_energy_zone_effect.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_knight_dark_energy_zone_thinker","heroes/DarkKnight/modifier_dark_knight_dark_energy_zone_thinker.lua",LUA_MODIFIER_MOTION_NONE)


function dark_knight_dark_energy_zone:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function dark_knight_dark_energy_zone:OnSpellStart()
	CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_dark_knight_dark_energy_zone_thinker",
		{ 
			duration = self:GetSpecialValueFor("duration") 
		},
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
	)	
end											