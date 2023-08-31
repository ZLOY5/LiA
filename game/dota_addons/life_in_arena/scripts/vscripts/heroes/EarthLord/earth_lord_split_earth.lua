earth_lord_split_earth = class({})
LinkLuaModifier("modifier_earth_lord_split_earth_thinker","heroes/EarthLord/modifier_earth_lord_split_earth_thinker.lua",LUA_MODIFIER_MOTION_NONE)

function earth_lord_split_earth:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function earth_lord_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function earth_lord_split_earth:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function earth_lord_split_earth:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "stun_duration" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.vPos = self:GetCursorPosition()
		self.damage = self:GetSpecialValueFor( "damage" )
		self.caster = self:GetCaster()
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self.vPos, 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

		for k,v in pairs (targets) do
			ApplyDamage({ victim = v, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
			v:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.duration})
		end 

		self.splitEarthParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl( self.splitEarthParticle, 0, self.vPos )
		ParticleManager:SetParticleControl( self.splitEarthParticle, 1, Vector( self.radius, 1, 1 ) )
		StartSoundEventFromPosition("Hero_Leshrac.Split_Earth", self.vPos)
	end
end
