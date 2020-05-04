treant_sharp_thorns = class({})
LinkLuaModifier("modifier_treant_sharp_thorns_debuff","heroes/Treant/modifier_treant_sharp_thorns_debuff.lua",LUA_MODIFIER_MOTION_NONE)


function treant_sharp_thorns:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function treant_sharp_thorns:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "duration" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.damage = self:GetSpecialValueFor( "damage" )
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
			ApplyDamage({ victim = v, attacker = self.caster, ability = self, damage_type = DAMAGE_TYPE_PURE, damage = self.damage })
		end 

		self.sharpThornsParticle = ParticleManager:CreateParticle("particles/custom/treant/treant_sharp_thorns.vpcf",PATTACH_WORLDORIGIN,self.caster)
		ParticleManager:SetParticleControl( self.sharpThornsParticle, 0, self.vPos )
		-- ParticleManager:SetParticleControl( self.splitEarthParticle, 1, Vector( self.radius, 1, 1 ) )
		StartSoundEventFromPosition("Hero_Bristleback.QuillSpray.Cast", self.vPos)
	end
end
