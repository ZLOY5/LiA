---@class marksman_ricochet:CDOTA_Ability_Lua
marksman_ricochet = class({})

LinkLuaModifier("modifier_marksman_ricochet_slow", "heroes/Marksman/marksman_ricochet.lua", LUA_MODIFIER_MOTION_NONE)

function marksman_ricochet:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- Initialize bounce tracking
    self.jumps = 0
    self.targets_table = {}

    -- Cache KV values
    self.damage               = self:GetSpecialValueFor("damage")
    self.attack_reduction     = self:GetSpecialValueFor("attack_reduction")
    self.attack_reduction_dur = self:GetSpecialValueFor("attack_reduction_duration")
    self.bounces              = self:GetSpecialValueFor("bounce_count")
    self.bounce_damage_pct    = self:GetSpecialValueFor("bounce_damage_pct")
    self.projectile_speed     = self:GetSpecialValueFor("projectile_speed")
    self.bounce_range         = self:GetSpecialValueFor("bounce_range")

    -- Launch first projectile
    ProjectileManager:CreateTrackingProjectile({
        Target               = target,
        Source               = caster,
        Ability              = self,
        EffectName           = "particles/custom/marksman/marksman_ricochet.vpcf",
        iMoveSpeed           = self.projectile_speed,
        bDodgeable           = false,
        bProvidesVision      = false,
        iSourceAttachment    = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    })
    caster:EmitSound("Hero_Sniper.AssassinateProjectile")
end

function marksman_ricochet:OnProjectileHit(hTarget, vLocation)
    if not hTarget or hTarget:IsNull() then return end
    local caster = self:GetCaster()

    -- Count this hit
    table.insert(self.targets_table, hTarget)
    self.jumps = self.jumps + 1

    -- 1) Deal damage
    local atk = caster:GetAverageTrueAttackDamage(hTarget)
    local ratio = self:GetSpecialValueFor("bounce_damage_pct") * 0.01
    local base = self:GetSpecialValueFor("damage")

    local totalDmg = base + atk * ratio
    ApplyDamage({
        victim      = hTarget,
        attacker    = caster,
        damage      = totalDmg,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self,
    })

    hTarget:EmitSound("Hero_Sniper.AssassinateDamage")

    -- 2) Apply slow debuff
    hTarget:AddNewModifier(caster, self, "modifier_marksman_ricochet_slow", {
        duration = self.attack_reduction_dur,
    })

    -- 3) Trigger Explosive Rounds if present
    local expl = hTarget:FindModifierByName("modifier_marksman_explosive_rounds_debuff")
    if expl then
        if not (hTarget:IsRealHero() or hTarget:IsBoss() or hTarget:IsMegaboss()) then
            hTarget:Kill(ability, caster)
        end
    end

    -- 4) Bounce to next valid target
    if self.jumps < self.bounces then
        local units = FindUnitsInRadius(
            caster:GetTeamNumber(),
            hTarget:GetAbsOrigin(),
            nil,
            self.bounce_range,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false
        )
        for _,enemy in ipairs(units) do
            -- skip already hit units
            local already = false
            for _,u in ipairs(self.targets_table) do
                if u == enemy then
                    already = true
                    break
                end
            end
            if not already then
                ProjectileManager:CreateTrackingProjectile({
                    Target               = enemy,
                    Source               = hTarget,
                    Ability              = self,
                    EffectName           = "particles/custom/marksman/marksman_ricochet.vpcf",
                    iMoveSpeed           = self.projectile_speed,
                    bDodgeable           = false,
                    bProvidesVision      = false,
                    iSourceAttachment    = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                })
                break
            end
        end
    end

    return true
end

---@class modifier_marksman_ricochet_slow:CDOTA_Modifier_Lua
modifier_marksman_ricochet_slow = class({})

function modifier_marksman_ricochet_slow:IsHidden()    return false end
function modifier_marksman_ricochet_slow:IsDebuff()    return true  end
function modifier_marksman_ricochet_slow:IsPurgable()  return true  end

function modifier_marksman_ricochet_slow:OnCreated(kv)
    local ability = self:GetAbility()
    self.attack_reduction = ability:GetSpecialValueFor("attack_reduction")
end

function modifier_marksman_ricochet_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,     
    }
end

function modifier_marksman_ricochet_slow:GetModifierBaseDamageOutgoing_Percentage()
    return -self.attack_reduction
end

function modifier_marksman_ricochet_slow:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf"
end

function modifier_marksman_ricochet_slow:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW 
end
