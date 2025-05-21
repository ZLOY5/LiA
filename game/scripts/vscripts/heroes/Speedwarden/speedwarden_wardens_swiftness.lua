--====================================================
-- scripts/vscripts/heroes/Speedwarden/speedwarden_wardens_swiftness.lua
--====================================================
---@class speedwarden_wardens_swiftness:CDOTA_Ability_Lua
if speedwarden_wardens_swiftness == nil then speedwarden_wardens_swiftness = class({}) end

LinkLuaModifier("modifier_speedwarden_wardens_swiftness", "heroes/Speedwarden/speedwarden_wardens_swiftness.lua", LUA_MODIFIER_MOTION_NONE)

function speedwarden_wardens_swiftness:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    -- Apply swiftness buff
    caster:AddNewModifier(caster, self, "modifier_speedwarden_wardens_swiftness", { duration = duration })
    
    caster:EmitSound("Hero_Dark_Seer.Surge")
end

------------------------------------------------------
-- Modifier: ultimate buff for Warden's Swiftness
------------------------------------------------------
---@class modifier_speedwarden_wardens_swiftness:CDOTA_Modifier_Lua
modifier_speedwarden_wardens_swiftness = class({})

function modifier_speedwarden_wardens_swiftness:IsHidden()   return false end
function modifier_speedwarden_wardens_swiftness:IsPurgable() return false end

function modifier_speedwarden_wardens_swiftness:OnCreated(kv)
    if not IsServer() then return end
    self.parent = self:GetParent()

    -- initialize pass-through damage tracking
    self.pass_radius = 100    -- radius to detect passing-through
    self.pass_damage = 100    -- fixed physical damage
    self.damaged = {}

    -- start checking movement collisions
    self:StartIntervalThink(0.1)
end

function modifier_speedwarden_wardens_swiftness:OnIntervalThink()
    if not IsServer() then return end

    -- pass-through damage: detect enemy units hero moves through
    local units = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.pass_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    for _,unit in pairs(units) do
        local id = unit:entindex()
        if not self.damaged[id] then
            self.damaged[id] = true
            local timeStrikeSkill = self:GetCaster():FindAbilityByName("speedwarden_time_strike")
            if timeStrikeSkill and timeStrikeSkill:GetLevel() > 0 then
                timeStrikeSkill:DealTimeStrikeDamage(self.parent, unit, true)
            end
        end
    end
end

function modifier_speedwarden_wardens_swiftness:OnDestroy()
    if not IsServer() then return end
    -- stop interval thinker
    self:StartIntervalThink(-1)
end

function modifier_speedwarden_wardens_swiftness:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_speedwarden_wardens_swiftness:DeclareFunctions()
    return { MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT }
end

function modifier_speedwarden_wardens_swiftness:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_speedwarden_wardens_swiftness:GetEffectName()
    return "particles/custom/speedwarden/speedwarden_swiftness2.vpcf"
end

function modifier_speedwarden_wardens_swiftness:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
