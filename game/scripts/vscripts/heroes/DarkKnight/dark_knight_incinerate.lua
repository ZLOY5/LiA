---@class dark_knight_incinerate:CDOTA_Ability_Lua
dark_knight_incinerate = class({})

LinkLuaModifier("modifier_dark_knight_incinerate","heroes/DarkKnight/dark_knight_incinerate.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_knight_incinerate_debuff","heroes/DarkKnight/dark_knight_incinerate.lua",LUA_MODIFIER_MOTION_NONE)

function dark_knight_incinerate:OnToggle()
    if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dark_knight_incinerate", nil)
	else
		self:GetCaster():RemoveModifierByName("modifier_dark_knight_incinerate")
	end
end

------------------------------------------------------
-- Modifier: Internal stack tracker + attack listener
------------------------------------------------------
---@class modifier_dark_knight_incinerate:CDOTA_Modifier_Lua
modifier_dark_knight_incinerate = class({})

function modifier_dark_knight_incinerate:IsHidden()      return true  end
function modifier_dark_knight_incinerate:IsPurgable()    return false end
function modifier_dark_knight_incinerate:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_dark_knight_incinerate:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_dark_knight_incinerate:OnCreated()
    if IsServer() then RegisterOrbEffectModifier(self) end
    local ability = self:GetAbility()
    self.damage_per_stack = ability:GetSpecialValueFor("damage_per_stack")
    self.duration    = ability:GetSpecialValueFor("duration")
end

function modifier_dark_knight_incinerate:OnRefresh()
    self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
end

function modifier_dark_knight_incinerate:OnOrbImpact(event)
    if not IsServer() then return end
    local ability = self:GetAbility()
    local debuff = event.target:AddNewModifier(event.attacker, ability, "modifier_dark_knight_incinerate_debuff", {duration = self.duration})
    if not debuff then return end
    local stacks = debuff:GetStackCount() or 0
    stacks = stacks + 1
    debuff:SetStackCount(stacks)
    ApplyDamage({
        victim      = event.target,
        attacker    = event.attacker,
        damage      = self.damage_per_stack * stacks,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = ability
    })
end

------------------------------------------------------
-- Debuff: handles explosion on death
------------------------------------------------------
---@class modifier_dark_knight_incinerate_debuff:CDOTA_Modifier_Lua
modifier_dark_knight_incinerate_debuff = class({})

function modifier_dark_knight_incinerate_debuff:IsHidden()   return false end
function modifier_dark_knight_incinerate_debuff:IsPurgable() return true end

function modifier_dark_knight_incinerate_debuff:DeclareFunctions()
    return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_dark_knight_incinerate_debuff:GetEffectName()
    return "particles/ogre_magi_ignite_debuff_d_blue.vpcf"
end

function modifier_dark_knight_incinerate_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dark_knight_incinerate_debuff:OnDeath(params)
    if not IsServer() then return end
    local parent = self:GetParent()
    local ability = self:GetAbility()

    if params.unit == parent then
        local caster  = self:GetCaster()
        local pos     = parent:GetAbsOrigin()

        local damage = ability:GetSpecialValueFor("incineration_damage")
        local radius = ability:GetSpecialValueFor("incineration_radius")
        local mana_restored = ability:GetSpecialValueFor("kill_mana_per_stack") * self:GetStackCount()

        caster:GiveMana(mana_restored)

        parent:EmitSound("Hero_OgreMagi.Fireblast.Cast")

        local pfx = ParticleManager:CreateParticle(
            "particles/ogre_magi_unr_fireblast_blue.vpcf",
            PATTACH_POINT_FOLLOW,
            parent
        )
        ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
        ParticleManager:SetParticleControl(pfx, 1, pos)
        ParticleManager:ReleaseParticleIndex(pfx)

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
end