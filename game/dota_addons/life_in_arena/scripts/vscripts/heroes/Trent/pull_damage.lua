function Vacuum_damage( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local dmg = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local more_dmg = ability:GetLevelSpecialValueFor("damage_2_x", ability:GetLevel() - 1 )

	if target:HasModifier("modifier_treant_root") then
		ApplyDamage({ victim = target, attacker = caster, damage = more_dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	else
		ApplyDamage({ victim = target, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	end	
end