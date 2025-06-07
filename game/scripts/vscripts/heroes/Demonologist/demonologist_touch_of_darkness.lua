---@class demonologist_touch_of_darkness:CDOTA_Ability_Lua
demonologist_touch_of_darkness = class ({})
LinkLuaModifier("modifier_demonologist_touch_of_darkness","heroes/Demonologist/demonologist_touch_of_darkness.lua",LUA_MODIFIER_MOTION_NONE)

function demonologist_touch_of_darkness:GetIntrinsicModifierName()
	return "modifier_demonologist_touch_of_darkness"
end

---@class modifier_demonologist_touch_of_darkness:CDOTA_Modifier_Lua
modifier_demonologist_touch_of_darkness = class({})

function modifier_demonologist_touch_of_darkness:IsHidden() return true end
function modifier_demonologist_touch_of_darkness:IsPurgable() return false end
function modifier_demonologist_touch_of_darkness:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_demonologist_touch_of_darkness:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.damage_percentage = self.ability:GetSpecialValueFor("damage_percentage")
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_demonologist_touch_of_darkness:OnRefresh()
	self.damage_percentage = self.ability:GetSpecialValueFor("damage_percentage")
end

function modifier_demonologist_touch_of_darkness:GetOrbProjectileName()
	return "particles/custom/demonologist/rod_of_atos_attack.vpcf"
end

function modifier_demonologist_touch_of_darkness:IsOrbActive(event)
	if self.parent:GetCurrentActiveAbility() ~= self.ability and not self.ability:GetAutoCastState() then return false end
	if event.target:IsMagicImmune() then return false end

	if self.ability:IsFullyCastable() and self.ability:IsOwnersManaEnough() and self.ability:IsCooldownReady() then return true end
end

function modifier_demonologist_touch_of_darkness:OnOrbFire(event)
	self.ability:UseResources(true, true, true, true)
end

function modifier_demonologist_touch_of_darkness:OnOrbImpact(event)
    if not IsServer() then return end

    local caster = self.parent
    local target = event.target

    if not target or target:IsNull() then return end

    local full_damage = caster:GetHealth() * self.damage_percentage * 0.01

    local particleName = "particles/custom/demonologist/shadow_demon_shadow_poison_impact_demionologist.vpcf"
    local pfx = ParticleManager:CreateParticle(
        particleName,
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:ReleaseParticleIndex(pfx)

    target:EmitSound("Hero_ShadowDemon.ShadowPoison.Impact")

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        if not enemy or enemy:IsNull() then
            goto continue
        end

        local damageToDeal = (enemy == target) and full_damage or (full_damage * 0.5)
        local damageTable = {
            victim      = enemy,
            attacker    = caster,
            damage      = damageToDeal,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability     = self.ability,
        }
        ApplyDamage(damageTable)

        ::continue::
    end
end
