function StormBolt(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	local damage_main_target = ability:GetSpecialValueFor("damage_main_target_tooltip")
	local damage_radius = ability:GetSpecialValueFor("damage_radius")

	local stun_main_target_duration = ability:GetSpecialValueFor("stun_main_target_duration")
	local stun_radius_duration = ability:GetSpecialValueFor("stun_radius_duration")

	local radius = ability:GetSpecialValueFor("radius")

	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	target:EmitSound("Hero_Sven.StormBoltImpact")
	ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	for _,unit in pairs(targets) do 
		if unit == target then
			ApplyDamage({victim = unit, attacker = caster, damage = damage_main_target, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_stunned", {duration = stun_main_target_duration})
		else
			ApplyDamage({victim = unit, attacker = caster, damage = damage_radius, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_stunned", {duration = stun_radius_duration})
		end
	end
end