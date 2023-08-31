paladin_grace = class ({})


function paladin_grace:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function paladin_grace:GetAOERadius()
	self.radius = self:GetSpecialValueFor( "radius" )
	return self.radius
end

function paladin_grace:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if caster:HasScepter() then
			self.primary_target_heal = self:GetSpecialValueFor( "primary_target_heal_scepter" )
		else
			self.primary_target_heal = self:GetSpecialValueFor( "primary_target_heal" )
		end

		self.radius = self:GetSpecialValueFor( "radius" )
		self.nearby_allies_heal = self:GetSpecialValueFor( "nearby_allies_heal" )
		
		local casterParticleName = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
		local targetParticleName = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"

		local casterParticle = ParticleManager:CreateParticle( casterParticleName, PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl( casterParticle, 0, caster:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(casterParticle)

		local target = self:GetCursorTarget()
		local targets = FindUnitsInRadius(caster:GetTeamNumber(),
										target:GetAbsOrigin(),
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

		for _,v in pairs(targets) do
			if v == target then
				v:Heal(self.primary_target_heal, caster)
			else
				v:Heal(self.nearby_allies_heal, caster)	
			end
		
			local FXIndex = ParticleManager:CreateParticle( targetParticleName, PATTACH_POINT_FOLLOW, v)
			ParticleManager:SetParticleControl( FXIndex, 0, v:GetAbsOrigin() )
			ParticleManager:SetParticleControl( FXIndex, 1, Vector(self.radius, self.radius, self.radius) )
			ParticleManager:ReleaseParticleIndex(FXIndex)
		end
			

		EmitSoundOn("Hero_Omniknight.Purification", target)
	end
end
