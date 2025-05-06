---@class ranger_trap:CDOTA_Ability_Lua
ranger_trap = class({})
LinkLuaModifier("modifier_ranger_trap_debuff","heroes/Ranger/ranger_trap.lua",LUA_MODIFIER_MOTION_NONE)

function ranger_trap:OnSpellStart()
	self.caster = self:GetCaster()
	local point = self:GetCursorPosition()

	EmitSoundOn("Hero_Meepo.Earthbind.Cast", self.caster)

	self:ThrowNet(point)
end

function ranger_trap:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function ranger_trap:ThrowNet(vLocation)
    local speed = self:GetSpecialValueFor("projectile_speed")

	EmitSoundOnLocationWithCaster(vLocation, "Hero_Meepo.Earthbind.Target", self.caster)

	self.net_dummy = CreateUnitByName("dummy_unit", vLocation, false, self.caster, self.caster, self.caster:GetTeam())

	local info = {
        EffectName = "particles/custom/ranger/ranger_trap_projectile.vpcf",
        Ability = self,
        iMoveSpeed = speed,
        Source = self.caster,
        Target = self.net_dummy,
        bDodgeable = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }

    ProjectileManager:CreateTrackingProjectile( info )

    self.caster:EmitSound("Hero_Meepo.Earthbind.Cast")
end

function ranger_trap:OnProjectileHit(hTarget, vLocation)
	local radius = self:GetSpecialValueFor("radius")
    local damage = self:GetSpecialValueFor("damage")

	if hTarget then
        hTarget:EmitSound("Hero_Meepo.Earthbind.Target")
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										hTarget:GetAbsOrigin(),
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										FIND_ANY_ORDER, 
										false)

        for _,v in pairs(targets) do
            ApplyDamage({
                victim      = v,
                attacker    = self.caster,
                damage      = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability     = self,
            })
            self:ApplyTrap(v)
        end

		self.net_dummy:ForceKill(false)
	end
end

function ranger_trap:ApplyTrap(hTarget)
    local duration = self:GetSpecialValueFor("duration")
    hTarget:AddNewModifier(self.caster, self, "modifier_ranger_trap_debuff", {duration = duration})
end


---@class modifier_ranger_trap_debuff:CDOTA_Modifier_Lua
modifier_ranger_trap_debuff = class({})

function modifier_ranger_trap_debuff:IsDebuff() return true end
function modifier_ranger_trap_debuff:IsPurgable() return true end
function modifier_ranger_trap_debuff:IsHidden() return false end

function modifier_ranger_trap_debuff:OnCreated(table)
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()

        self.break_damage = self:GetAbility():GetSpecialValueFor("damage_to_release")
        self.accum_damage = 0
	end
end

function modifier_ranger_trap_debuff:CheckState()
	local state = { [MODIFIER_STATE_ROOTED] = true,
					[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_ranger_trap_debuff:GetPriority()
    return MODIFIER_PRIORITY_HIGH
  end

function modifier_ranger_trap_debuff:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_ranger_trap_debuff:OnTakeDamage(params)
    if params.unit == self:GetParent() and params.attacker ~= self:GetParent() then
        self.accum_damage = self.accum_damage + params.damage
        if self.accum_damage >= self.break_damage then
            self:Destroy()
        end
    end
end

function modifier_ranger_trap_debuff:GetEffectName()
	return "particles/custom/ranger/ranger_trap.vpcf"
end

function modifier_ranger_trap_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end