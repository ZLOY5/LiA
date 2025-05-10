---@class marksman_explosive_rounds:CDOTA_Ability_Lua
if marksman_explosive_rounds == nil then marksman_explosive_rounds = class({}) end

LinkLuaModifier("modifier_marksman_explosive_rounds","heroes/Marksman/marksman_explosive_rounds.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marksman_explosive_rounds_debuff","heroes/Marksman/marksman_explosive_rounds.lua",LUA_MODIFIER_MOTION_NONE)

function marksman_explosive_rounds:GetIntrinsicModifierName()
    return "modifier_marksman_explosive_rounds"
end

------------------------------------------------------
-- Ability: Explosion handler
------------------------------------------------------
function marksman_explosive_rounds:Explode(target)
    if not IsServer() then return end
    local caster  = self:GetCaster()
    -- Don't explode if passives are disabled
    if caster:PassivesDisabled() then return end

    local ability = self
    local pos     = target:GetAbsOrigin()

    local damage = ability:GetSpecialValueFor("explosion_damage")
    local radius = ability:GetSpecialValueFor("damage_radius")

    target:EmitSound("Hero_Sniper.ConcussiveGrenade")

    -- Explosion particle effect
    local pfx = ParticleManager:CreateParticle(
        "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)

    -- Damage all enemy units in radius
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), pos, nil, radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER, false)

    for _,enemy in pairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = ability
        })
    end
end

------------------------------------------------------
-- Modifier: Internal stack tracker + attack listener
------------------------------------------------------
---@class modifier_marksman_explosive_rounds:CDOTA_Modifier_Lua
modifier_marksman_explosive_rounds = class({})

function modifier_marksman_explosive_rounds:IsHidden()      return true  end
function modifier_marksman_explosive_rounds:IsPurgable()    return false end
function modifier_marksman_explosive_rounds:RemoveOnDeath() return false end

function modifier_marksman_explosive_rounds:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_marksman_explosive_rounds:OnCreated()
    if not IsServer() then return end
    local ability = self:GetAbility()
    self.dmg_per_shot = ability:GetSpecialValueFor("dmg_per_shot")
    self.shots_limit = ability:GetSpecialValueFor("shots_limit")
    self.duration    = ability:GetSpecialValueFor("duration")
end

function modifier_marksman_explosive_rounds:OnRefresh()
    if not IsServer() then return end
    self.dmg_per_shot = self:GetAbility():GetSpecialValueFor("dmg_per_shot")
end

function modifier_marksman_explosive_rounds:OnAttackLanded(event)
    if not IsServer() then return end
    local caster  = self:GetParent()
    local ability = self:GetAbility()

    -- Only count if attacker is caster and passives active
    if event.attacker ~= caster or caster:PassivesDisabled() then return end
    -- Only count basic attacks
    if event.inflictor then return end

    local target = event.target
    if not target or target:IsNull() or target:IsOther() then return end

    -- If target died immediately, trigger explosion and exit
    if not target:IsAlive() then
            ability:Explode(target)
        return
    end

    -- Track stacks for explosion
    local debuff = target:AddNewModifier(caster, ability, "modifier_marksman_explosive_rounds_debuff", {duration = self.duration})
    if not debuff then return end
    local stacks = debuff:GetStackCount() or 0
    stacks = stacks + 1
    debuff:SetStackCount(stacks)

    -- Apply extra damage per shot
    ApplyDamage({
        victim      = target,
        attacker    = caster,
        damage      = self.dmg_per_shot * stacks,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = ability
    })

    

    if stacks >= self.shots_limit then
        if not (target:IsRealHero() or target:IsBoss() or target:IsMegaboss()) then
            ability:Explode(target)
        end
        debuff:Destroy()
    end
end

------------------------------------------------------
-- Debuff: handles explosion on death
------------------------------------------------------
---@class modifier_marksman_explosive_rounds_debuff:CDOTA_Modifier_Lua
modifier_marksman_explosive_rounds_debuff = class({})

function modifier_marksman_explosive_rounds_debuff:IsHidden()   return false end
function modifier_marksman_explosive_rounds_debuff:IsPurgable() return true end

function modifier_marksman_explosive_rounds_debuff:DeclareFunctions()
    return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_marksman_explosive_rounds_debuff:OnStackCountChanged(iStackCount)
    if not IsServer() then return end
  
    if not self.pfx then
      self.pfx = ParticleManager:CreateParticle("particles/custom/marksman/marksman_explosive_rounds_stack_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    end
  
    ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
    ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end

function modifier_marksman_explosive_rounds_debuff:OnDestroy()
    if not IsServer() then return end

    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
    end
end

function modifier_marksman_explosive_rounds_debuff:OnDeath(event)
    if not IsServer() then return end
    if event.unit ~= self:GetParent() then return end

    local ability = self:GetAbility()
    local caster  = ability:GetCaster()
    if caster:PassivesDisabled() then
        self:Destroy()
        return
    end

    ability:Explode(event.unit)
    self:Destroy()
end