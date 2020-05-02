treant_craving_for_nature = class({})
LinkLuaModifier("modifier_treant_craving_for_nature_movement","heroes/Treant/modifier_treant_craving_for_nature_movement.lua",LUA_MODIFIER_MOTION_NONE)

function treant_craving_for_nature:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		self.target_point = self.caster:GetAbsOrigin()
		self.radius = self:GetSpecialValueFor("radius")
		self.tick_time = self:GetSpecialValueFor("tick_time")
		self.distance_per_tick = self:GetSpecialValueFor("distance_per_tick")
		self.speed = self.distance_per_tick / self.tick_time

		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.target_point,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

		for _,v in pairs(targets) do
			local distance = (v:GetAbsOrigin() - self.target_point):Length2D()
			local duration = distance / self.speed
			v:AddNewModifier(self.caster, self, "modifier_treant_craving_for_nature_movement", {duration = duration})
		end
		local particleName = "particles/custom/treant/treant_craving_for_nature.vpcf"

		self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self.caster)
		ParticleManager:SetParticleControl( self.FXIndex, 0, self.caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex(self.FXIndex)
		EmitSoundOn( "Hero_Treant.NaturesGrasp.Cast", self.caster ) 
	end
end
