---@class marksman_marksmans_mastery:CDOTA_Ability_Lua
marksman_marksmans_mastery = class({})
LinkLuaModifier( "modifier_marksman_marksmans_mastery", "heroes/Marksman/marksman_marksmans_mastery.lua", LUA_MODIFIER_MOTION_NONE )

function marksman_marksmans_mastery:GetIntrinsicModifierName()
    return "modifier_marksman_marksmans_mastery"
end


---@class marksman_marksmans_mastery:CDOTA_Modifier_Lua
marksman_marksmans_mastery = class({})

function marksman_marksmans_mastery:IsHidden()      return true  end
function marksman_marksmans_mastery:IsPurgable()    return false end
function marksman_marksmans_mastery:RemoveOnDeath() return false end

function marksman_marksmans_mastery:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }
end

function marksman_marksmans_mastery:OnCreated()
    if not IsServer() then return end
    self:OnRefresh()
end

function marksman_marksmans_mastery:OnRefresh()
    local ability = self:GetAbility()
    self.bonus_range      = ability:GetSpecialValueFor("bonus_range")
    self.bonus_dmg_creeps = ability:GetSpecialValueFor("bonus_damage_pct_creeps")
    self.bonus_dmg_heroes = ability:GetSpecialValueFor("bonus_damage_pct_heroes")
end

function marksman_marksmans_mastery:GetModifierAttackRangeBonus()
    return self.bonus_range or 0
end

function modifier_marksman_marksmans_mastery:GetModifierProcAttack_BonusDamage_Physical(keys)
    if keys.attacker ~= self:GetParent() then
        return 0
    end

    local target = keys.target
    if not target or target:IsNull() or target:IsOther() then
        return 0
    end

    -- Determine percentage based on target type
    local pct = target:IsRealHero() and self.bonus_dmg_heroes or self.bonus_dmg_creeps
    local baseDamage = keys.damage or 0
    return baseDamage * pct * 0.01
end
