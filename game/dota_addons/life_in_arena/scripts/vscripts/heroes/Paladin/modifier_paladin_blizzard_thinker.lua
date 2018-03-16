modifier_paladin_blizzard_thinker = class({})

function modifier_paladin_blizzard_thinker:OnCreated(kv)
	self.tick = self:GetAbility():GetSpecialValueFor("wave_interval")
	self:StartIntervalThink(self.tick)
end

function modifier_paladin_blizzard_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	local damage = ability:GetSpecialValueFor(caster:HasScepter() and "wave_damage_scepter" or "wave_damage")
	local stun_duration = ability:GetSpecialValueFor("stun")
	local radius = ability:GetSpecialValueFor("radius")

	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"

	local position = self:GetParent():GetAbsOrigin()

	local pFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pFX, 0, position )
	ParticleManager:ReleaseParticleIndex(pFX)

	Timers:CreateTimer(0.05, function() 
		pFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 	ParticleManager:SetParticleControl( pFX, 0, position + RandomVector(radius/2) )
	 	ParticleManager:ReleaseParticleIndex(pFX)
	end)

	Timers:CreateTimer(0.1, function() 
		pFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 	ParticleManager:SetParticleControl( pFX, 0, position + RandomVector(radius/2) )
	 	ParticleManager:ReleaseParticleIndex(pFX)
	end)

	Timers:CreateTimer(0.15, function() 
		pFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 	ParticleManager:SetParticleControl( pFX, 0, position + RandomVector(radius-50) )
	 	ParticleManager:ReleaseParticleIndex(pFX)
	end)

	Timers:CreateTimer(0.2, function() 
		pFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 	ParticleManager:SetParticleControl( pFX, 0, position + RandomVector(radius-50) )
	 	ParticleManager:ReleaseParticleIndex(pFX)
	end)
	
	Timers:CreateTimer(0.5, function()

    	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
    		position,
    		nil,
    		radius,
    		DOTA_UNIT_TARGET_TEAM_ENEMY,
    		DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
    		DOTA_UNIT_TARGET_FLAG_NONE,
    		FIND_ANY_ORDER,
    		false)

    	for _,unit in pairs(targets) do
    		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
    		unit:AddNewModifier(caster,ability,"modifier_stunned",{duration = stun_duration})
    	end

    	EmitSoundOn("hero_Crystal.freezingField.explosion", self:GetParent())

    end)

end