function PhoenixBurn( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local damage = 20
	local ion_particle = "particles/lion_spell_finger_of_death_top1.vpcfs"

	-- Targeting variables
	local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH
	local target_types = ability:GetAbilityTargetType() 
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	-- Initialize the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage = damage
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	damage_table.ability = ability

	-- Find all the valid units in radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

			local particle = ParticleManager:CreateParticle(ion_particle, PATTACH_POINT_FOLLOW, target) 
			ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true) 
			ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
			damage_table.victim = target
			ApplyDamage(damage_table)

end