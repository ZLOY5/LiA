archmage_anomaly = class({})
LinkLuaModifier("modifier_archmage_anomaly_effect","heroes/Archmage/modifier_archmage_anomaly_effect.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_archmage_anomaly_thinker","heroes/Archmage/modifier_archmage_anomaly_thinker.lua",LUA_MODIFIER_MOTION_NONE)


function archmage_anomaly:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function archmage_anomaly:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function archmage_anomaly:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasScepter() then
		self.duration = self:GetSpecialValueFor( "duration_scepter" )
	else
		self.duration = self:GetSpecialValueFor( "duration" )
	end
	CreateModifierThinker(
		caster,
		self,
		"modifier_archmage_anomaly_thinker",
		{ 
			duration = self.duration 
		},
		self:GetCursorPosition(),
		caster:GetTeamNumber(),
		false
	)	
	self.anomaly_dummy = CreateUnitByName("dummy_unit_anomaly", self:GetCursorPosition(), false, caster, caster, caster:GetTeam())
	self.anomaly_dummy:SetControllableByPlayer(caster:GetPlayerID(), true)
	self.anomaly_dummy:AddNewModifier(caster, nil, "modifier_kill", {duration = self.duration})
end											