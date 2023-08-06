function ArrowOfDarkness(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targets = event.target_entities
	local damage = caster:GetHealth() * ability:GetSpecialValueFor("damage_percentage") * 0.01
	for _,v in pairs(targets) do
		if v ~= target then
			ApplyDamage({ victim = v, attacker = caster, damage = damage/2, damage_type = DAMAGE_TYPE_PHYSICAL, ability = event.ability })
		else
			ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = event.ability })
		end
	end

	
end
