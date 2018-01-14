modifier_dark_knight_dark_energy_zone_thinker = class({})

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetModifierAura()
	return "modifier_dark_knight_dark_energy_zone_effect"
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetAuraDuration()
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		self.DarkEnergyZoneParticle = ParticleManager:CreateParticle("particles/custom/dark_knight/dark_knight_dark_energy_zone.vpcf",PATTACH_ABSORIGIN,self:GetParent())
		ParticleManager:SetParticleControl(self.DarkEnergyZoneParticle,1,Vector(self.radius,self.radius,self.radius))
		self:GetParent():EmitSound("Hero_Abaddon.BorrowedTime")
	end
end

--------------------------------------------------------------------------------

function modifier_dark_knight_dark_energy_zone_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.DarkEnergyZoneParticle,true)
		self:GetParent():StopSound("Hero_Abaddon.BorrowedTime")
	end
end

--------------------------------------------------------------------------------