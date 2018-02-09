warlock_storm = class({})

function warlock_storm:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function warlock_storm:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function warlock_storm:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.target = self:GetCursorPosition()

	if self:GetCaster():HasScepter() then
		self.damage = self:GetSpecialValueFor( "damage_scepter" )
	else
		self.damage = self:GetSpecialValueFor( "damage" )
	end

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
		ApplyDamage({victim = v, attacker = self:GetCaster(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage})
	end

	local particleName = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.target )
	ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.target.x, self.target.y, self.target.z+1000 ) )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_Zuus.LightningBolt", self:GetCaster() )
end
