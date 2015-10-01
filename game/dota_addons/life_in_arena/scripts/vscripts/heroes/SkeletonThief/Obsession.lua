function Obsession(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local level = ability:GetLevel()
	local damage = ability:GetLevelSpecialValueFor("damage", level-1)
	local number_of_attacks = ability:GetLevelSpecialValueFor("number_of_attacks", level-1)

	if not ability.attacks then
		ability.attacks = 0
	end

	ability.attacks = ability.attacks + 1

	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if ability.attacks == number_of_attacks then
			ability.attacks = 0
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
		end
	end
	
end