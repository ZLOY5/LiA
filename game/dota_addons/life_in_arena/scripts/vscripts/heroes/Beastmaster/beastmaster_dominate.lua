beastmaster_dominate = class({})
LinkLuaModifier("modifier_beastmaster_dominate","heroes/Beastmaster/modifier_beastmaster_dominate.lua",LUA_MODIFIER_MOTION_NONE)

function beastmaster_dominate:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function beastmaster_dominate:OnSpellStart() 
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "duration" )
	local damage = self:GetSpecialValueFor( "damage" )

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
										self.target,
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										FIND_ANY_ORDER, 
										false)


	for _,v in pairs(targets) do
		if not v:IsBoss() and not v:IsMegaboss() and not v:IsHero() and not v:IsIllusion() then
			v:AddNewModifier(self:GetCaster(), self, "modifier_beastmaster_dominate", {duration = duration})
		else
			ApplyDamage({victim = v, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
		end
	end

	local particleName = "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.target )
	ParticleManager:SetParticleControl( self.FXIndex, 1, self.target )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_LoneDruid.SpiritBear.Cast", self:GetCaster() )
end