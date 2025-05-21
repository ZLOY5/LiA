---@class speedwarden_speed_burst:CDOTA_Ability_Lua
speedwarden_speed_burst = class({})

function speedwarden_speed_burst:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_speedwarden_wardens_swiftness") then
		return self.BaseClass.GetCooldown( self, iLevel ) / 2
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function speedwarden_speed_burst:OnSpellStart()
    local caster = self:GetCaster()
    local radius      = self:GetSpecialValueFor("radius")
    local base_damage = self:GetSpecialValueFor("base_damage")
    local damage_pct  = self:GetSpecialValueFor("damage_pct") / 100.0

    local caster_speed = caster:GetIdealSpeed()

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        local enemy_speed = enemy:GetIdealSpeed()
        local speed_diff = math.max(caster_speed - enemy_speed, 0)
        local extra_damage = speed_diff * damage_pct
        local total_damage = base_damage + extra_damage
        
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = total_damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self
        })
    end

   local particleName = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl( self.FXIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.FXIndex, 1, Vector(radius*1.5,0,0) )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_FacelessVoid.TimeDilation.Cast", caster )
end
