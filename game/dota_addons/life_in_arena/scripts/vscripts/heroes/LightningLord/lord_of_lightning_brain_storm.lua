lord_of_lightning_brain_storm = class({})
LinkLuaModifier("modifier_lord_of_lightning_brain_storm_debuff","heroes/LightningLord/modifier_lord_of_lightning_brain_storm_debuff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_of_lightning_brain_storm_disarm","heroes/LightningLord/modifier_lord_of_lightning_brain_storm_disarm.lua",LUA_MODIFIER_MOTION_NONE)

-- function lord_of_lightning_brain_storm:GetCooldown(iLevel)
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
-- 	end

-- 	return self.BaseClass.GetCooldown( self, iLevel ) 
-- end

function lord_of_lightning_brain_storm:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function lord_of_lightning_brain_storm:OnSpellStart()
	self.caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.disarm_duration = self:GetSpecialValueFor( "disarm_duration" )

	local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do
		v:AddNewModifier(self.caster, self, "modifier_lord_of_lightning_brain_storm_debuff", {duration = self.duration})
		v:AddNewModifier(self.caster, self, "modifier_lord_of_lightning_brain_storm_disarm", {duration = self.disarm_duration})
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_POINT, v)
		-- ParticleManager:SetParticleControlEnt(particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true) 
		-- ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
	end

	EmitSoundOn( "Hero_Disruptor.StaticStorm.Cast", self:GetCaster() )
end
