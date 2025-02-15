---@class android_cluster_rockets:CDOTA_Ability_Lua
android_cluster_rockets = class({})
LinkLuaModifier("modifier_cluster_rockets", "heroes/Android/android_cluster_rockets", LUA_MODIFIER_MOTION_NONE)

function android_cluster_rockets:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function android_cluster_rockets:OnSpellStart()
	local caster = self:GetCaster()

	self.target_position = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("projectile_interval") * self:GetSpecialValueFor("projectile_count") + 0.01
	caster:AddNewModifier(caster, self, "modifier_cluster_rockets", { duration = duration})
	caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
end

function android_cluster_rockets:OnProjectileHit(target, location)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("projectile_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	local damage_table = {
		attacker = caster,
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	local targets = FindUnitsInRadius(
		caster:GetTeam(),
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, unit in pairs(targets) do
		damage_table.victim = unit
		ApplyDamage(damage_table)

		unit:AddNewModifier(caster, self, "modifier_bashed", {duration = stun_duration})
	end

	target:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
	ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_ABSORIGIN, target)
end

function android_cluster_rockets:OnChannelFinish(interrupted)
	self:GetCaster():RemoveModifierByName("modifier_cluster_rockets")
end


---@class modifier_cluster_rockets:CDOTA_Modifier_Lua
modifier_cluster_rockets = class({})

function modifier_cluster_rockets:IsHidden() return true end
function modifier_cluster_rockets:IsPurgable() return false end
function modifier_cluster_rockets:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_cluster_rockets:OnCreated()
	if IsClient() then return end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local interval = ability:GetSpecialValueFor("projectile_interval")

	self:StartIntervalThink(interval)

	local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(fx, 0, caster, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack1", Vector(0,0,0), false)
	self:AddParticle(fx, false, false, 0, false, false)
end

function modifier_cluster_rockets:OnIntervalThink()
	self:FireRocket()
end

function modifier_cluster_rockets:FireRocket()
	-- Variables
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local radius =  ability:GetSpecialValueFor("radius")
	local projectile_speed =  ability:GetSpecialValueFor("projectile_speed")
	local particle_name = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"

	-- Create a dummy on the area to make the rocket track it
	local random_position = ability.target_position + RandomVector(RandomInt(0,radius))
	local dummy = CreateUnitByName("dummy_unit_vulnerable", random_position, false, caster, caster, DOTA_UNIT_TARGET_TEAM_ENEMY)

	ProjectileManager:CreateTrackingProjectile({
		EffectName = particle_name,
		Ability = ability,
		Target = dummy,
		Source = caster,
		bDodgeable = false,
		bProvidesVision = false,
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = projectile_speed,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	})

	Timers:CreateTimer(3, function() dummy:RemoveSelf() end)
end
