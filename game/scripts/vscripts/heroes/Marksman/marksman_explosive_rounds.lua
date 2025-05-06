---@class marksman_explosive_rounds:CDOTA_Ability_Lua
marksman_explosive_rounds = class({})
LinkLuaModifier("modifier_marksman_explosive_rounds", "heroes/Marksman/marksman_explosive_rounds.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marksman_explosive_rounds_debuff", "heroes/Marksman/marksman_explosive_rounds.lua", LUA_MODIFIER_MOTION_NONE)

function marksman_explosive_rounds:GetIntrinsicModifierName()
    return "modifier_marksman_explosive_rounds"
end


---@class modifier_marksman_explosive_rounds:CDOTA_Modifier_Lua
modifier_marksman_explosive_rounds = class({})
function modifier_marksman_explosive_rounds:IsHidden() return true end
function modifier_marksman_explosive_rounds:IsPurgable() return false end
function modifier_marksman_explosive_rounds:RemoveOnDeath() return false end

function modifier_marksman_explosive_rounds:OnCreated(kv)
    if not IsServer() then return end
    self:OnRefresh(kv)
end

function modifier_marksman_explosive_rounds:OnRefresh(kv)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    local lvl = self.ability:GetLevel() - 1

    self.dmg_per_shot  = self.ability:GetLevelSpecialValueFor("dmg_per_shot", lvl)
    self.duration      = self.ability:GetSpecialValueFor("duration")
    self.shots_limit   = self.ability:GetSpecialValueFor("shots_limit")
end

function modifier_marksman_explosive_rounds:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_marksman_explosive_rounds:OnAttackLanded(params)
    if not IsServer() then return end
    local parent = self:GetParent()
    if params.attacker ~= parent then return end

    local target = params.target
    if not target or not target:IsAlive() then return end

    

    -- 2) Apply or refresh debuff stacks
    local debuff = target:FindModifierByName("modifier_marksman_explosive_rounds_debuff")
    if not debuff then
        debuff = target:AddNewModifier(parent, self.ability, "modifier_marksman_explosive_rounds_debuff", { duration = self.duration })
        debuff:SetStackCount(1)
    else
        debuff:IncrementStackCount()
        debuff:SetDuration(self.duration, true)
    end

    ApplyDamage({
        victim      = target,
        attacker    = parent,
        damage      = self.dmg_per_shot * debuff:GetStackCount(),
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self.ability,
    })

    -- 3) Trigger explosion via debuff when limit reached
    if debuff:GetStackCount() >= self.shots_limit then
        debuff:Explode()
    end
end

---@class modifier_marksman_explosive_rounds_debuff:CDOTA_Modifier_Lua
modifier_marksman_explosive_rounds_debuff = class({})

function modifier_marksman_explosive_rounds_debuff:IsHidden()      return false end
function modifier_marksman_explosive_rounds_debuff:IsPurgable()    return true  end
function modifier_marksman_explosive_rounds_debuff:RemoveOnDeath() return true  end

function modifier_marksman_explosive_rounds_debuff:OnCreated(kv)
    if not IsServer() then return end
    self:OnRefresh(kv)
end

function modifier_marksman_explosive_rounds_debuff:OnRefresh(kv)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    local lvl     = self.ability:GetLevel() - 1

    -- Cache explosion parameters
    self.explosion_damage = self.ability:GetLevelSpecialValueFor("explosion_damage", lvl)
    self.damage_radius    = self.ability:GetSpecialValueFor("damage_radius")
    self.shots_limit      = self.ability:GetSpecialValueFor("shots_limit")
end

--- Triggers the explosion and destroys this debuff
function modifier_marksman_explosive_rounds_debuff:Explode()
    if not IsServer() then return end

    local parent  = self:GetParent()
    local caster  = self:GetCaster()
    local self.ability = self:GetAbility()
    local pos     = parent:GetAbsOrigin()
    local team    = caster:GetTeamNumber()

    local enemies = FindUnitsInRadius(
        team,
        pos,
        nil,
        self.damage_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        ApplyDamage({
            victim      = enemy,
            attacker    = caster,
            damage      = self.explosion_damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability     = self.ability,
        })
    end

    self:Destroy()
end