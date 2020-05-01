treant_sharp_thorns = class({})
LinkLuaModifier("modifier_treant_sharp_thorns_debuff","heroes/Treant/modifier_treant_sharp_thorns_debuff.lua",LUA_MODIFIER_MOTION_NONE)


function treant_sharp_thorns:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function treant_sharp_thorns:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "duration" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.vPos = self:GetCursorPosition()
		self.caster = self:GetCaster()
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self.vPos, 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
												FIND_ANY_ORDER, 
												false)

		for k,v in pairs (targets) do
			v:AddNewModifier(self.caster, self, "modifier_treant_sharp_thorns_debuff", {duration = self.duration})
		end 

		-- self.splitEarthParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf",PATTACH_WORLDORIGIN,caster)
		-- ParticleManager:SetParticleControl( self.splitEarthParticle, 0, self.vPos )
		-- ParticleManager:SetParticleControl( self.splitEarthParticle, 1, Vector( self.radius, 1, 1 ) )
		-- StartSoundEventFromPosition("Hero_Leshrac.Split_Earth", self.vPos)
	end
end
