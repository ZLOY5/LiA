keeper_of_the_grove_natures_curse = class({})
LinkLuaModifier("modifier_keeper_of_the_grove_natures_curse_damage","heroes/KeeperOfTheGrove/modifier_keeper_of_the_grove_natures_curse_damage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keeper_of_the_grove_natures_curse_disarm","heroes/KeeperOfTheGrove/modifier_keeper_of_the_grove_natures_curse_disarm.lua",LUA_MODIFIER_MOTION_NONE)

function keeper_of_the_grove_natures_curse:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function keeper_of_the_grove_natures_curse:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function keeper_of_the_grove_natures_curse:OnAbilityPhaseStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	local present_targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	local count = 0

	for _,v in pairs(present_targets) do
		count = count + 1
	end

	if count == 0 then
		SendErrorMessage(self:GetCaster():GetPlayerOwnerID(), "#lia_hud_error_keeper_of_the_grove_natures_curse_no_targets")
		return false
	end

	return true
end

function keeper_of_the_grove_natures_curse:OnSpellStart()
	local caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

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
		if v:IsHero() then
			if v:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
				v:AddNewModifier(caster, self, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = self.hero_duration})
			end
			v:AddNewModifier(caster, self, "modifier_keeper_of_the_grove_natures_curse_damage", {duration = self.hero_duration})
		else
			if v:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
				v:AddNewModifier(caster, self, "modifier_keeper_of_the_grove_natures_curse_disarm", {duration = self.duration})
			end
			v:AddNewModifier(caster, self, "modifier_keeper_of_the_grove_natures_curse_damage", {duration = self.duration})
		end
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_POINT, v)
		ParticleManager:SetParticleControlEnt(particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
	end

	EmitSoundOn( "Hero_Treant.Overgrowth.Cast", self:GetCaster() )
end
