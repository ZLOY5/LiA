﻿--[[
    Author: Noya
    Creates a dummy unit to apply the Rain of Fire thinker modifier which does the waves
]]
function RainOfFireStart( event )
    local caster = event.caster
    local point = event.target_points[1]
    local ability = event.ability

    caster.fire_storm_dummy = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
    event.ability:ApplyDataDrivenModifier(caster, caster.fire_storm_dummy, "modifier_rain_of_fire_thinker", {duration=ability:GetChannelTime()-0.5})
end

function ApplyAnimation(event)
    local ability = event.ability
    local caster = event.caster

    Timers:CreateTimer(0.5, function()
        local start_time = ability:GetChannelStartTime()
        local time_channeled = GameRules:GetGameTime() - start_time
        local max_channel_time = ability:GetChannelTime()
        if ability:IsChanneling() and (time_channeled < max_channel_time-1) then
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        end
    end)
end

function StopAnimation(event)
    event.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
end

function RainOfFireWave(event)
    local caster = event.caster
    local ability = event.ability
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetLevelSpecialValueFor("wave_damage",ability:GetLevel()-1)
    local target_position = event.target:GetAbsOrigin() --event.target_points[1]
    local particleName = "particles/custom/neutral/firestorm_wave.vpcf"
    local distance = 100
    local firestormTargets = FindUnitsInRadius(caster:GetTeam(), 
																target_position, 
																nil, radius, 
																DOTA_UNIT_TARGET_TEAM_ENEMY, 
																DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
																0, 
																FIND_ANY_ORDER, 
																false)

    local firestorm = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(firestorm, 0, target_position)
    ParticleManager:SetParticleControl(firestorm, 4, Vector(radius, 1, 1))

    caster:EmitSound("Hero_AbyssalUnderlord.Firestorm.Cast")

    for _,v in pairs(firestormTargets) do
			ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	end
end

function RainOfFireEnd( event )
    local caster = event.caster

    caster.fire_storm_dummy:RemoveSelf()
end