demonologist_ritual_of_summoning = class({})
LinkLuaModifier("modifier_demonologist_ritual_of_summoning_thinker", "heroes/Demonologist/modifier_demonologist_ritual_of_summoning_thinker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demonologist_ritual_of_summoning_creep_debuff", "heroes/Demonologist/modifier_demonologist_ritual_of_summoning_creep_debuff.lua", LUA_MODIFIER_MOTION_NONE)

function demonologist_ritual_of_summoning:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function demonologist_ritual_of_summoning:GetAOERadius()
	return self:GetSpecialValueFor( "spawn_radius" )
end

function demonologist_ritual_of_summoning:OnSpellStart()
	self.target = self:GetCursorPosition()
	self.delay = self:GetSpecialValueFor( "delay" )
	self.caster = self:GetCaster()

	CreateModifierThinker(
		self.caster,
		self,
		"modifier_demonologist_ritual_of_summoning_thinker",
		{ 
			duration = self.delay 
		},
		self.target,
		self.caster:GetTeamNumber(),
		false
	)
end

