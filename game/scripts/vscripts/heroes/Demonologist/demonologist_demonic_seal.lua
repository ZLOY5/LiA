demonologist_demonic_seal = class({})
LinkLuaModifier("modifier_demonologist_demonic_seal_debuff", "heroes/Demonologist/modifier_demonologist_demonic_seal_debuff.lua", LUA_MODIFIER_MOTION_NONE)

function demonologist_demonic_seal:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function demonologist_demonic_seal:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function demonologist_demonic_seal:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "initial_duration" )
	local additional_duration = self:GetSpecialValueFor( "additional_duration" )

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	duration = duration + #targets * additional_duration 

	for _,v in pairs(targets) do
		v:AddNewModifier(self:GetCaster(), self, "modifier_demonologist_demonic_seal_debuff", {duration = duration})
	end

	local particleName = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_new.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.target )
	ParticleManager:SetParticleControl( self.FXIndex, 1, self.target )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_ShadowDemon.Soul_Catcher.Cast", self:GetCaster() )
end
