---@class ranger_volley_of_arrows:CDOTA_Ability_Lua
ranger_volley_of_arrows = class({})
LinkLuaModifier("modifier_ranger_volley_trap", "heroes/Ranger/ranger_volley_of_arrows.lua", LUA_MODIFIER_MOTION_NONE)

function ranger_volley_of_arrows:OnSpellStart()
    local caster = self:GetCaster()
    local origin = caster:GetAbsOrigin()

    -- load KV
    local count     = self:GetSpecialValueFor("arrow_count")
    local coneDeg   = self:GetSpecialValueFor("cone_angle")
    self.baseDmg    = self:GetSpecialValueFor("damage_base")
    self.kbDist     = self:GetSpecialValueFor("knockback_dist")
    self.kbDur      = self:GetSpecialValueFor("knockback_dur")
    self.trapDur    = self:GetSpecialValueFor("trap_root_dur")
    local speed     = self:GetSpecialValueFor("arrow_speed")
    local width     = self:GetSpecialValueFor("arrow_width")
    local range     = self:GetSpecialValueFor("arrow_range")

    -- compute cone
    local forward = (self:GetCursorPosition() - origin):Normalized()
    local coneRad = math.rad(coneDeg)
    local step    = coneRad / (count - 1)
    local start   = -coneRad * 0.5

    -- fire each arrow in that cone
    for i = 0, count - 1 do
        local theta = start + step * i
        local dir = Vector(
            forward.x * math.cos(theta) - forward.y * math.sin(theta),
            forward.x * math.sin(theta) + forward.y * math.cos(theta),
            0
        )

        ProjectileManager:CreateLinearProjectile({
            Ability           = self,
            EffectName        = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
            vSpawnOrigin      = origin,
            fDistance         = range,
            fStartRadius      = width,
            fEndRadius        = width,
            Source            = caster,
            vVelocity         = dir * speed,
            iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bDeleteOnHit      = false,  -- pierce
            bProvidesVision   = false,
        })
    end

    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    caster:EmitSound("Hero_Windrunner.Windrun")  -- choose an appropriate sound
end

function ranger_volley_of_arrows:OnProjectileHit(target, _)
    if not target then return false end

    local caster = self:GetCaster()
    -- damage
    ApplyDamage({
        victim      = target,
        attacker    = caster,
        damage      = self.baseDmg,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self,
    })

    -- knockback away from caster
    local knockback = {
        should_stun        = 0,
        knockback_duration = self.kbDur,
        duration           = self.kbDur,
        knockback_distance = self.kbDist,
        knockback_height   = 0,
        center_x           = caster:GetAbsOrigin().x,
        center_y           = caster:GetAbsOrigin().y
    }
    target:AddNewModifier(caster, self, "modifier_knockback", knockback)

    -- trap root
    target:AddNewModifier(caster, self, "modifier_ranger_volley_trap", { duration = self.trapDur })

    return false  -- continue piercing
end


---@class modifier_ranger_volley_trap:CDOTA_Modifier_Lua
modifier_ranger_volley_trap = class({})

function modifier_ranger_volley_trap:IsHidden()    return false end
function modifier_ranger_volley_trap:IsDebuff()    return true  end
function modifier_ranger_volley_trap:IsPurgable()  return false end

function modifier_ranger_volley_trap:CheckState()
    return {
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
