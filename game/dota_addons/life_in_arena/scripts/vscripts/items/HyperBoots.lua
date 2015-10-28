--[[
    Author: Bude
    Date: 30.09.2015.
    Sets some initial values and prepares the caster for motion controllers
    NOTE: Modifier that keeps huskar from attacking (etc.) does not get removed properly if Life Break is cancelled
]]
function LifeBreak( keys )
    -- Variables
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local charge_speed = ability:GetLevelSpecialValueFor("charge_speed", (ability:GetLevel() - 1)) * 1/30

    -- Save modifiernames in ability
    ability.modifiername = keys.ModifierName
    ability.modifiername_debuff = keys.ModifierName_Debuff

    -- Motion Controller Data
    ability.target = target
    ability.velocity = charge_speed
    ability.life_break_z = 0
    ability.initial_distance = (GetGroundPosition(target:GetAbsOrigin(), target)-GetGroundPosition(caster:GetAbsOrigin(), caster)):Length2D()
    ability.traveled = 0
end


function DoDamage(caster, target, ability)
    -- Variables
    local dmg_to_target = ability:GetSpecialValueFor("damage")
    local target_location = target:GetAbsOrigin()
    local stun_radius = ability:GetSpecialValueFor("radius")

    local targets = FindUnitsInRadius(target:GetTeam(), target_location, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    for _,v in pairs(targets) do
           ApplyDamage({
                                victim = v,
                                attacker = caster,
                                damage = dmg_to_target,
                                damage_type = DAMAGE_TYPE_MAGICAL
                            })
           ability:ApplyDataDrivenModifier(caster, v, ability.modifiername_debuff, {duration = ability:GetSpecialValueFor("stun_duration")})
    end    
end

function AutoAttack(caster, target)
        order = 
        {
            UnitIndex = caster:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = target:GetEntityIndex(),
            Queue = true
        }

        ExecuteOrderFromTable(order)
end

function OnMotionDone(caster, target, ability)
    -- Variables
    local modifiername = ability.modifiername
    local modifiername_debuff = ability.modifiername_debuff

    --Remove self modifier
    if caster:FindModifierByName(modifiername) then
        caster:RemoveModifierByName(modifiername)
    end

    -- FireSound
    EmitSoundOn("Hero_Huskar.Life_Break.Impact", target)

    --Particles and effects
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)


    

    DoDamage(caster, target, ability)

    AutoAttack(caster, target)
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function JumpHorizonal( keys )
    -- Variables
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target

    local target_loc = GetGroundPosition(target:GetAbsOrigin(), target)
    local caster_loc = GetGroundPosition(caster:GetAbsOrigin(), caster)
    local direction = (target_loc - caster_loc):Normalized()

    local max_distance = ability:GetLevelSpecialValueFor("max_distance", ability:GetLevel()-1)


    -- Max distance break condition
    if (target_loc - caster_loc):Length2D() >= max_distance then
        caster:InterruptMotionControllers(true)
    end

    -- Moving the caster closer to the target until it reaches the enemy
    if (target_loc - caster_loc):Length2D() > 100 then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + direction * ability.velocity)
        ability.traveled = ability.traveled + ability.velocity
    else
        caster:InterruptMotionControllers(true)

        -- Move the caster to the ground
        caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))

        OnMotionDone(caster, target, ability)
    end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function JumpVertical( keys )
    -- Variables
    local caster = keys.target
    local ability = keys.ability
    local target = ability.target
    local caster_loc = caster:GetAbsOrigin()
    local caster_loc_ground = GetGroundPosition(caster_loc, caster)

    -- If we happen to be under the ground just pop the caster up
    if caster_loc.z < caster_loc_ground.z then
        caster:SetAbsOrigin(caster_loc_ground)
    end

    -- For the first half of the distance the unit goes up and for the second half it goes down
    if ability.traveled < ability.initial_distance/2 then
        -- Go up
        -- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
        ability.life_break_z = ability.life_break_z + ability.velocity/2
        -- Set the new location to the current ground location + the memorized z point
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    elseif caster_loc.z > caster_loc_ground.z then
        -- Go down
        ability.life_break_z = ability.life_break_z - ability.velocity/2
        caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    end

end