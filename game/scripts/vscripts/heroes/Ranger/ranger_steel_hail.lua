---@class ranger_steel_hail:CDOTA_Ability_Lua
ranger_steel_hail = class({})
LinkLuaModifier("modifier_ranger_steel_hail_debuff", "heroes/Ranger/ranger_steel_hail.lua", LUA_MODIFIER_MOTION_NONE)

function ranger_steel_hail:OnSpellStart()
    local caster = self:GetCaster()

    -- pull values from KV
    local count    = self:GetSpecialValueFor("arrow_count")
    local interval = self:GetSpecialValueFor("interval")
    local baseDmg  = self:GetSpecialValueFor("damage_base")
    local atkRatio = self:GetSpecialValueFor("attack_ratio") * 0.01
    local speed    = self:GetSpecialValueFor("arrow_speed")
    local width    = self:GetSpecialValueFor("arrow_width")
    local range    = self:GetSpecialValueFor("arrow_range")

    -- calculate how long the barrage lasts
    local totalDuration = count * interval

    -- apply custom root+disarm modifier
    caster:AddNewModifier(caster, self, "modifier_ranger_steel_hail_debuff", {
        duration = interval * (count - 1)
    })

    -- store origin so all arrows fire from the same spot
    self._origin = caster:GetAbsOrigin()

    -- schedule each arrow
    for i = 0, count - 1 do
        caster:SetContextThink("steel_hail_"..i, function()
            if not caster:IsAlive() then return nil end

            local dir = caster:GetForwardVector()

            caster:StartGesture(ACT_DOTA_ATTACK)

            ProjectileManager:CreateLinearProjectile({
                Ability           = self,
                EffectName        = "particles/custom/ranger/ranger_steel_hail_arrow.vpcf",
                vSpawnOrigin      = self._origin,
                fDistance         = range,
                fStartRadius      = width,
                fEndRadius        = width,
                Source            = caster,
                vVelocity         = dir * speed,
                iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                bDeleteOnHit      = false,
                bProvidesVision   = false,
            })

            caster:EmitSoundParams("Ability.Powershot", 1, 0.4, 0)

        end, interval * i)
    end
end

function ranger_steel_hail:OnProjectileHit(target, _)
    if not target then return false end

    local caster = self:GetCaster()
    local atk = caster:GetAverageTrueAttackDamage(caster)
    local ratio = self:GetSpecialValueFor("attack_ratio") * 0.01
    local base = self:GetSpecialValueFor("damage_base")
    local totalDmg = base + atk * ratio

    ApplyDamage({
        victim      = target,
        attacker    = caster,
        damage      = totalDmg,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self,
    })

    return false  
end

---@class modifier_ranger_steel_hail_debuff:CDOTA_Modifier_Lua
modifier_ranger_steel_hail_debuff = class({})

function modifier_ranger_steel_hail_debuff:IsHidden()      return false end
function modifier_ranger_steel_hail_debuff:IsDebuff()      return true  end
function modifier_ranger_steel_hail_debuff:IsPurgable()    return false end

function modifier_ranger_steel_hail_debuff:CheckState()
    return {
        [MODIFIER_STATE_ROOTED]    = true,
        [MODIFIER_STATE_DISARMED]  = true,
    }
end
