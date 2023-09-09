function DealDamage( event )
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities
	local damage = event.Damage
	local damage_to_deal = ((caster:GetStrength() + caster:GetIntellect() + caster:GetAgility())*ability:GetLevelSpecialValueFor("stat_percentage", ability:GetLevel() - 1 )*0.01 + ability:GetLevelSpecialValueFor("constant_damage", ability:GetLevel() - 1 ))
	for _,v in pairs(targets) do
			ApplyDamage({ victim = v, attacker = caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })	
	end
end