huntress_curse_of_elune = class({})
LinkLuaModifier("modifier_huntress_curse_of_elune","heroes/Huntress/modifier_huntress_curse_of_elune.lua",LUA_MODIFIER_MOTION_NONE)

function huntress_curse_of_elune:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function huntress_curse_of_elune:OnSpellStart() 
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "duration" )

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)


	for _,v in pairs(targets) do
		v:AddNewModifier(self:GetCaster(), self, "modifier_huntress_curse_of_elune", {duration = duration})
	end

	local particleName = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.target )
	ParticleManager:SetParticleControl( self.FXIndex, 1, self.target )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_FacelessVoid.TimeDilation.Cast", self:GetCaster() )
end