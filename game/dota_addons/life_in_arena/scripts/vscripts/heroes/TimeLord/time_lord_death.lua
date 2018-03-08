time_lord_death = class({})

function time_lord_death:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function time_lord_death:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function time_lord_death:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do
		if not string.find(v:GetUnitName(),"boss") then 
			v:Kill(self, self:GetCaster())
		end
	end

	local particleName = "particles/units/heroes/hero_silencer/silencer_curse_cast.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.target )
	ParticleManager:SetParticleControl( self.FXIndex, 1, self.target )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_Magnataur.ReversePolarity.Cast", self:GetCaster() )
end
