function Curse(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	local fullDamageRadius = ability:GetSpecialValueFor("full_damage_radius")
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")

	local damageTable = {
		attacker = caster,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	for _,unit in pairs(targets) do
		local range = unit:GetRangeToUnit(caster)
		if range > fullDamageRadius then
			damageTable.damage = damage * (1 - ((range-fullDamageRadius) / (radius-fullDamageRadius)) )
		else
			damageTable.damage = damage
		end
		damageTable.victim = unit
		ApplyDamage(damageTable)
	end
end
