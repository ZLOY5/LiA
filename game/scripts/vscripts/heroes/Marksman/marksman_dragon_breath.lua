---@class marksman_dragon_breath:CDOTA_Ability_Lua
marksman_dragon_breath = class({})
LinkLuaModifier("modifier_marksman_dragon_breath_debuff", "heroes/Marksman/marksman_dragon_breath.lua", LUA_MODIFIER_MOTION_NONE)

function marksman_dragon_breath:OnAbilityPhaseStart()
    EmitSoundOn("Hero_Snapfire.Shotgun.Load", self:GetCaster())
    return true
end

function marksman_dragon_breath:OnAbilityPhaseInterrupted()
    StopSoundOn("Hero_Snapfire.Shotgun.Load", self:GetCaster())
end

function marksman_dragon_breath:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()

    -- Cache KV values
    local lvl             = self:GetLevel() - 1
    self.damage           = self:GetLevelSpecialValueFor("damage",          lvl)
    self.armor_reduction  = self:GetLevelSpecialValueFor("armor_reduction", lvl)
    self.move_slow_pct    = self:GetLevelSpecialValueFor("move_slow_pct",   lvl)
    self.slow_duration    = self:GetSpecialValueFor("slow_duration")
    self.distance         = self:GetSpecialValueFor("distance")
    self.speed            = self:GetSpecialValueFor("speed")
    self.start_radius     = self:GetSpecialValueFor("start_radius")
    self.end_radius       = self:GetSpecialValueFor("end_radius")

    -- Direction of the breath
    local dir = (point - caster:GetAbsOrigin()):Normalized()

    -- Create the linear projectile
    ProjectileManager:CreateLinearProjectile({
        Ability             = self,
        EffectName          = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf",
        vSpawnOrigin        = caster:GetAbsOrigin(),
        fDistance           = self.distance,
        fStartRadius        = self.start_radius,
        fEndRadius          = self.end_radius,
        Source              = caster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime         = GameRules:GetGameTime() + 4.0,
        vVelocity           = dir * self.speed,
    })

    EmitSoundOn("Hero_Snapfire.Shotgun.Fire", self:GetCaster())
end

function marksman_dragon_breath:OnProjectileHit(target, location)
    if not target or target:IsNull() then return end
    local caster = self:GetCaster()

    -- Deal damage
    ApplyDamage({
        victim      = target,
        attacker    = caster,
        damage      = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability     = self,
    })

    -- Apply debuff
    target:AddNewModifier(caster, self, "modifier_marksman_dragon_breath_debuff", {
        duration         = self.slow_duration,
        armor_reduction  = self.armor_reduction,
        move_slow_pct    = self.move_slow_pct,
    })

    return false
end


---@class modifier_marksman_dragon_breath_debuff:CDOTA_Modifier_Lua
modifier_marksman_dragon_breath_debuff = class({})

function modifier_marksman_dragon_breath_debuff:IsHidden()    return false end
function modifier_marksman_dragon_breath_debuff:IsDebuff()    return true  end
function modifier_marksman_dragon_breath_debuff:IsPurgable()  return true  end

function modifier_marksman_dragon_breath_debuff:OnCreated(kv)
    if not IsServer() then return end
    -- Read custom kv params (fall back to ability values)
    self.armor_reduction = kv.armor_reduction
    self.move_slow_pct   = kv.move_slow_pct
end

function modifier_marksman_dragon_breath_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_marksman_dragon_breath_debuff:GetModifierPhysicalArmorBonus()
    return -self.armor_reduction
end

function modifier_marksman_dragon_breath_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.move_slow_pct
end

function modifier_marksman_dragon_breath_debuff:GetEffectName()
	return "particles/custom/marksman/modifier_marksman_dragon_breath_debuffvpcf.vpcf"	
end

function modifier_marksman_dragon_breath_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
