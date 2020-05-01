skeleton_mage_light_magic = class({})

function skeleton_mage_light_magic:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "manacost_scepter" )
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function skeleton_mage_light_magic:OnSpellStart()
	local caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor( "radius" )

	if self:GetCaster():HasScepter() then
		self.damage_constant = self:GetSpecialValueFor( "damage_constant_scepter" )
		self.damage_percentage = self:GetSpecialValueFor( "damage_percentage_scepter" )
		self.heal_constant = self:GetSpecialValueFor( "heal_constant_scepter" )
		self.heal_percentage = self:GetSpecialValueFor( "heal_percentage_scepter" )
	else
		self.damage_constant = self:GetSpecialValueFor( "damage_constant" )
		self.damage_percentage = self:GetSpecialValueFor( "damage_percentage" )
		self.heal_constant = self:GetSpecialValueFor( "heal_constant" )
		self.heal_percentage = self:GetSpecialValueFor( "heal_percentage" )
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
										self:GetCaster():GetAbsOrigin(),
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_BOTH, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do
		local max_health = v:GetMaxHealth()
		if v:GetTeamNumber() ~= caster:GetTeamNumber() then
			local damage_to_deal = (max_health * self.damage_percentage * 0.01 + self.damage_constant)
			ApplyDamage({ victim = v, attacker = caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })
		else
			local heal = (max_health * self.heal_percentage * 0.01 + self.heal_constant)
			v:Heal(heal, caster)	
		end

	end

	local particleName = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_Pugna.NetherBlast", self:GetCaster() )
end
