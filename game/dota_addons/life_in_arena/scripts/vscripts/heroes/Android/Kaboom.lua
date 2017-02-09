function Kaboom(event)
	local caster = event.caster
	local ability = event.ability

	local damage = ability:GetAbilityDamage()/2
	local fullRadius = ability:GetSpecialValueFor("small_radius")
	local halfRadius = ability:GetSpecialValueFor("big_radius")

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		fullRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = ability})
	end

	targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		halfRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(targets) do
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = ability})
	end

	caster:EmitSound("Hero_Techies.Suicide")

	ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf",PATTACH_ABSORIGIN,caster)

	if caster:IsAlive() then
		caster:ForceKill(false)
	end

end