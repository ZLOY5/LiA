--====================================================
-- scripts/vscripts/heroes/Speedwarden/speedwarden_time_strike.lua
--====================================================
---@class speedwarden_time_strike:CDOTA_Ability_Lua
if speedwarden_time_strike == nil then speedwarden_time_strike = class({}) end

-- Aura provider
LinkLuaModifier("modifier_speedwarden_time_strike","heroes/Speedwarden/speedwarden_time_strike.lua",LUA_MODIFIER_MOTION_NONE)
-- Slow aura effect
LinkLuaModifier("modifier_speedwarden_time_strike_slow","heroes/Speedwarden/speedwarden_time_strike.lua",LUA_MODIFIER_MOTION_NONE)

function speedwarden_time_strike:GetIntrinsicModifierName()
    return "modifier_speedwarden_time_strike"
end

------------------------------------------------------
-- Helper: shared strike damage logic
------------------------------------------------------
function speedwarden_time_strike:DealTimeStrikeDamage(caster, target, ultimate)
    if not caster or caster:IsNull() or not target or target:IsNull() then return end
    local dmg_pct = self:GetSpecialValueFor("damage_pct")
    local ms = caster:GetIdealSpeed() or 0
    local damage = ms * dmg_pct * 0.01
    local chance = self:GetSpecialValueFor("base_chance")
    local chance_per_charge = self:GetSpecialValueFor("chance_per_charge")

    if not ultimate then
        local mad_charge = caster:HasModifier("modifier_speedwarden_mad_charge_buff")
        if mad_charge then
            chance = chance + mad_charge:GetStackCount()
        end
        if RollPercentage(chance) then 
            if not target:IsMagicImmune() then
                local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                ParticleManager:SetParticleControl(nFX, 1, target:GetAbsOrigin() )
                ParticleManager:ReleaseParticleIndex(nFX)
                ApplyDamage({ victim=target, attacker=caster, damage=damage, damage_type=DAMAGE_TYPE_MAGICAL, ability=self })
        	end   
        end
    else
        local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(nFX, 0, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl(nFX, 1, target:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt(nFX, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(nFX, 4, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl(nFX, 5, Vector(1,1,1) )
        ParticleManager:ReleaseParticleIndex(nFX)

        local delay = self:GetSpecialValueFor("strike_delay")
        Timers:CreateTimer(delay, 
        function()
            EmitSoundOn("Hero_FacelessVoid.Attack.Impact", target)
            local physDamage = caster:GetAverageTrueAttackDamage(target)
            ApplyDamage({ victim=target, attacker=caster, damage=physDamage, damage_type=DAMAGE_TYPE_PHYSICAL, ability=self })
            ApplyDamage({ victim=target, attacker=caster, damage=damage, damage_type=DAMAGE_TYPE_MAGICAL, ability=self })
        end)
    end  
end

------------------------------------------------------
-- Modifier: provides aura and listens attacks
------------------------------------------------------
---@class modifier_speedwarden_time_strike:CDOTA_Modifier_Lua
modifier_speedwarden_time_strike = class({})

function modifier_speedwarden_time_strike:IsHidden()      return true end
function modifier_speedwarden_time_strike:IsPurgable()    return false end
function modifier_speedwarden_time_strike:RemoveOnDeath() return false end

function modifier_speedwarden_time_strike:OnCreated()
    if not IsServer() then return end
    local ability = self:GetAbility()
    -- cache values
    self.radius      = ability:GetSpecialValueFor("radius")
end

-- aura
function modifier_speedwarden_time_strike:IsAura() return true end
function modifier_speedwarden_time_strike:GetModifierAura() return "modifier_speedwarden_time_strike_slow" end
function modifier_speedwarden_time_strike:GetAuraRadius() return self.radius end
function modifier_speedwarden_time_strike:GetAuraDuration() return self.delay end
function modifier_speedwarden_time_strike:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_speedwarden_time_strike:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end
function modifier_speedwarden_time_strike:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_speedwarden_time_strike:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_speedwarden_time_strike:OnAttackLanded(event)
    if not IsServer() then return end
    local caster = self:GetParent()
    if event.attacker ~= caster then return end

    local target = event.target
    if not target or target:IsNull() then return end

    self:GetAbility():DealTimeStrikeDamage(caster, target, false)
end



------------------------------------------------------
-- Debuff: slow effect for aura
------------------------------------------------------
---@class modifier_speedwarden_time_strike_slow:CDOTA_Modifier_Lua
modifier_speedwarden_time_strike_slow = class({})

function modifier_speedwarden_time_strike_slow:IsHidden()   return false end
function modifier_speedwarden_time_strike_slow:IsDebuff()   return true end
function modifier_speedwarden_time_strike_slow:IsPurgable() return true end

function modifier_speedwarden_time_strike_slow:OnCreated()
    self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
end

function modifier_speedwarden_time_strike_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_speedwarden_time_strike_slow:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow_pct
end
