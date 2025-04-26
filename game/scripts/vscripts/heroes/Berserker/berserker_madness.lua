if berserker_madness == nil then berserker_madness = class({}) end
LinkLuaModifier("modifier_berserker_madness","heroes/Berserker/berserker_madness.lua",LUA_MODIFIER_MOTION_NONE)

function berserker_madness:OnSpellStart()
    local caster = self:GetCaster()
    local ab     = self

    -- pull our numbers from the KV
    local bonusAll = ab:GetSpecialValueFor("bonus_all_stats")
    local dur      = ab:GetSpecialValueFor("duration")
    local redDelay = ab:GetSpecialValueFor("reduced_delay")

    -- apply the buff modifier carrying both values
    caster:AddNewModifier(
        caster, 
        ab, 
        "modifier_berserker_madness", 
        {
            duration      = dur,
            bonus_stats   = bonusAll,
            reduced_delay = redDelay
        }
    )

    -- VFX + SFX
    caster:EmitSound("Hero_Axe.Berserkers_Call")
    local p = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_troll_warlord/troll_warlord_rampage_resistance_buff.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        caster
    )
    ParticleManager:ReleaseParticleIndex(p)
end

-- =========================================
-- Modifier: Berserker Madness (buff, permanent)
-- =========================================
if modifier_berserker_madness == nil then modifier_berserker_madness = class({}) end

function modifier_berserker_madness:IsHidden()      return false end
function modifier_berserker_madness:IsDebuff()      return false end
function modifier_berserker_madness:IsPurgable()    return false end
function modifier_berserker_madness:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_berserker_madness:OnCreated(kv)
    if IsServer() then
        self.bonus_stats   = kv.bonus_stats
        self.reduced_delay = kv.reduced_delay
    end
end

function modifier_berserker_madness:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_berserker_madness:GetModifierBonusStats_Strength()
    return self.bonus_stats
end
function modifier_berserker_madness:GetModifierBonusStats_Agility()
    return self.bonus_stats
end
function modifier_berserker_madness:GetModifierBonusStats_Intellect()
    return self.bonus_stats
end

-- allow other scripts (like Fire Spear) to read the reduced_delay
function modifier_berserker_madness:GetChannelReduction()
    return self.reduced_delay
end