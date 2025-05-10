---@class ranger_volley_of_arrows:CDOTA_Ability_Lua
ranger_volley_of_arrows = class({})
LinkLuaModifier("modifier_ranger_fan_of_arrows_pull", "heroes/Ranger/ranger_volley_of_arrows.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function ranger_volley_of_arrows:OnSpellStart()
    self.caster = self:GetCaster()
    self.origin = self.caster:GetAbsOrigin()

    local count     = self:GetSpecialValueFor("arrow_count")
    local coneDeg   = self:GetSpecialValueFor("cone_angle")
    self.damage    = self:GetSpecialValueFor("damage")
    self.speed     = self:GetSpecialValueFor("arrow_speed")
    self.width     = self:GetSpecialValueFor("arrow_width")
    self.range     = self:GetSpecialValueFor("arrow_range")

    local forward = (self:GetCursorPosition() - self.origin):Normalized()
    local coneRad = math.rad(coneDeg)
    local step    = coneRad / (count - 1)
    local start   = -coneRad * 0.5

    self._hitTargets = {}

    for i = 0, count - 1 do
        local theta = start + step * i
        local dir = Vector(
            forward.x * math.cos(theta) - forward.y * math.sin(theta),
            forward.x * math.sin(theta) + forward.y * math.cos(theta),
            0
        )

        ProjectileManager:CreateLinearProjectile({
            Ability           = self,
            EffectName        = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
            vSpawnOrigin      = self.origin,
            fDistance         = self.range,
            fStartRadius      = self.width,
            fEndRadius        = self.width,
            Source            = self.caster,
            vVelocity         = dir * self.speed,
            iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bDeleteOnHit      = false,  
            bProvidesVision   = false,
            ExtraData         = { dir_x = dir.x, dir_y = dir.y },
        })
    end

    self.caster:EmitSound("Ability.Powershot")
end

function ranger_volley_of_arrows:OnProjectileHit_ExtraData(target, loc, extraData)
    if not target then return false end

    if self._hitTargets[target:entindex()] then
        return false
    end
    self._hitTargets[target:entindex()] = true

    ApplyDamage({
        victim      = target,
        attacker    = self.caster,
        damage      = self.damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability     = self,
    })

    -- apply pull modifier along remaining path
    local dir       = Vector(extraData.dir_x, extraData.dir_y, 0)
    local traveled  = (target:GetAbsOrigin() - self.origin):Dot(dir)
    local remain    = math.max(0, self.range - traveled)
    local duration  = remain / self.speed

    local trapped = target:FindModifierByName("modifier_ranger_trap_debuff")
    if trapped then
        trapped:Destroy()
    end

    target:AddNewModifier(self.caster, self, "modifier_ranger_fan_of_arrows_pull", {
        duration = duration,
        dir_x    = dir.x,
        dir_y    = dir.y,
        speed    = self.speed,
    })

    return false 
end


---@class modifier_ranger_fan_of_arrows_pull:CDOTA_Modifier_Lua
modifier_ranger_fan_of_arrows_pull = class({})

function modifier_ranger_fan_of_arrows_pull:IsHidden()   return false end
function modifier_ranger_fan_of_arrows_pull:IsDebuff()   return true  end
function modifier_ranger_fan_of_arrows_pull:IsPurgable() return false end

function modifier_ranger_fan_of_arrows_pull:IsMotionController() return true end
function modifier_ranger_fan_of_arrows_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_ranger_fan_of_arrows_pull:OnCreated(kv)
    if not IsServer() then return end
    self.dir   = Vector(kv.dir_x, kv.dir_y, 0)
    self.speed = kv.speed or 0

    if not self:ApplyHorizontalMotionController() then
        self:Destroy()
    end
end

function modifier_ranger_fan_of_arrows_pull:OnDestroy()
    if IsServer() then
        self:GetParent():InterruptMotionControllers(true)
        self:GetParent():RemoveHorizontalMotionController(self) 
        local trapAbility = self:GetCaster():FindAbilityByName("ranger_trap")
        if trapAbility and trapAbility:GetLevel() > 0 then
            trapAbility:ApplyTrap(self:GetParent())
        end
    end
end

function modifier_ranger_fan_of_arrows_pull:UpdateHorizontalMotion(me, dt)
    local newPos = me:GetAbsOrigin() + self.dir * self.speed * dt
    me:SetAbsOrigin(newPos)
end

function modifier_ranger_fan_of_arrows_pull:CheckState()
    return {
        [MODIFIER_STATE_STUNNED]   = true,
        [MODIFIER_STATE_DISARMED]  = true,
    }
end
