function StrikeOfDarkness(event)
	local target = event.target
	local caster = event.caster

	if target:GetTeamNumber() == caster:GetTeamNumber() then 
		return 
	end

	local ability = event.ability
	local mult = ability:GetSpecialValueFor("mult")
	local agi = caster:GetAgility()
	local num = RandomInt(1, agi)
	local damage = mult*num

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
	SendOverheadEventMessage(target:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL, target, damage, nil)
end