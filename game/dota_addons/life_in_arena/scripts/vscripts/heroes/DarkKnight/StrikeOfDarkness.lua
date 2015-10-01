function StrikeOfDarkness(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local mult = ability:GetLevelSpecialValueFor("mult", ability:GetLevel() - 1 )
	local agi = caster:GetAgility()
	local num = RandomInt(1, agi)
	local damage = mult*num

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
	SendOverheadEventMessage(target:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, target, damage, nil)
end