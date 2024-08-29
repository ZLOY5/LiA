---@class modifier_naga_siren_fury:CDOTA_Modifier_Lua
modifier_naga_siren_fury = class({})

function modifier_naga_siren_fury:IsHidden() return false end
function modifier_naga_siren_fury:IsPurgable() return false end
function modifier_naga_siren_fury:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_naga_siren_fury:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
end

function modifier_naga_siren_fury:OnOrbImpact(event)
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	local radius = ability:GetSpecialValueFor("radius")
	local stats = caster:GetStrength() + caster:GetIntellect(false) + caster:GetAgility()
	local damage = stats * ability:GetSpecialValueFor("stat_percentage") * 0.01 + ability:GetSpecialValueFor("constant_damage")

	local damage_table = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL, 
		ability = ability,
	}

	local targets = FindUnitsInRadius(
		caster:GetTeam(),
		event.target:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	for _, target in pairs(targets) do
		damage_table.victim = target
		ApplyDamage(damage_table)

		local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end
