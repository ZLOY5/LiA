if berserker_fire_spear == nil then berserker_fire_spear = class({}) end
LinkLuaModifier("modifier_berserker_fire_spear_slow", "heroes/Berserker/berserker_fire_spear.lua", LUA_MODIFIER_MOTION_NONE)

-- clamp channel based on Madness
function berserker_fire_spear:OnAbilityPhaseStart()
    if not IsServer() then return true end
    self._channelStart = GameRules:GetGameTime()
    return true
end

function berserker_fire_spear:GetChannelTime()
    if IsServer() then 
        self._channelFullTime = self:GetSpecialValueFor("original_channel")
        local mad = self:GetCaster():FindModifierByName("modifier_berserker_madness")
        if mad and mad.GetChannelReduction then
            self._channelFullTime = mad:GetChannelReduction()
        end
        return self._channelFullTime
    end
end

function berserker_fire_spear:GetPlaybackRateOverride()
    if IsServer() then 
        local mad = self:GetCaster():FindModifierByName("modifier_berserker_madness")
        if mad then
            return 0.42
        end
        return 0.21
    end
end

-- if interrupted, still throw
function berserker_fire_spear:OnChannelFinish(bInterrupted)
    if IsServer() then
        self._channelEnd = GameRules:GetGameTime()

        -- after setting self._channelEnd = GameRules:GetGameTime()
        local elapsed = self._channelEnd - self._channelStart
        -- clamp between 0 and full
        elapsed = math.max(0, math.min(elapsed, self._channelFullTime))
        -- fraction 0…1
        local ratio = elapsed / self._channelFullTime

        self:ThrowSpear(ratio)
    end
end

-- on successful channel end, throw
function berserker_fire_spear:OnSpellStart()
    if IsServer() then
        -- self:ThrowSpear()
    end
end

-- core spear logic
function berserker_fire_spear:ThrowSpear(nRatio)
    local caster    = self:GetCaster()
    local origin    = caster:GetAbsOrigin()
    local targetPt  = self:GetCursorPosition()
    local dir       = (targetPt - origin):Normalized()

    -- load KV
    local baseDmg   = self:GetSpecialValueFor("damage_base")
    local speed     = self:GetSpecialValueFor("spear_speed")
    local width     = self:GetSpecialValueFor("spear_width")
    local distance  = self:GetSpecialValueFor("spear_range")
    local vision    = self:GetSpecialValueFor("vision_aoe")
    local slowPct   = self:GetSpecialValueFor("slow_pct")
    local slowDur   = self:GetSpecialValueFor("slow_duration")

    -- sum primary stats
    local statsSum = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect(false)
    local totalDmg = baseDmg + statsSum * nRatio

    -- fire piercing projectile
    ProjectileManager:CreateLinearProjectile({
        Ability             = self,
        EffectName          = "particles/berserker_fire_spear.vpcf",
        vSpawnOrigin        = origin,
        fDistance           = distance,
        fStartRadius        = width,
        fEndRadius          = width,
        Source              = caster,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iUnitTargetFlags    = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        bDeleteOnHit        = false,
        vVelocity           = dir * speed,
        bProvidesVision     = true,
        iVisionRadius       = vision,
        iVisionTeamNumber   = caster:GetTeamNumber(),
    })

    caster:EmitSound("Hero_Huskar.Burning_Spear")

    -- cache for OnProjectileHit
    self._projDamage = totalDmg
    self._slowPct    = slowPct
    self._slowDur    = slowDur
end

-- handle projectile hits
function berserker_fire_spear:OnProjectileHit(target, _)
    if not target then return false end

    -- apply damage
    ApplyDamage({
        victim      = target,
        attacker    = self:GetCaster(),
        damage      = self._projDamage or 0,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self,
    })

    -- apply slow modifier
    target:AddNewModifier(
        self:GetCaster(),
        self,
        "modifier_berserker_fire_spear_slow",
        {
            duration = self._slowDur or 0,
            slow_pct = self._slowPct or 0
        }
    )

    return false  -- keep piercing
end

-- ===========================
-- Slow modifier definition
-- ===========================
if modifier_berserker_fire_spear_slow == nil then modifier_berserker_fire_spear_slow = class({}) end

function modifier_berserker_fire_spear_slow:IsHidden()    return false end
function modifier_berserker_fire_spear_slow:IsDebuff()    return true  end
function modifier_berserker_fire_spear_slow:IsPurgable()  return true  end

function modifier_berserker_fire_spear_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_berserker_fire_spear_slow:GetModifierMoveSpeedBonus_Percentage()
    return -(self.slow_pct or 0)
end

function modifier_berserker_fire_spear_slow:OnCreated(kv)
    if IsServer() then
        self.slow_pct = kv.slow_pct or 0
    end
end
