function DealDamage( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
			ApplyDamage({ victim = target, 
						attacker = caster, 
						damage = (target:GetMaxHealth()*ability:GetLevelSpecialValueFor("damage_percentage", ability:GetLevel() - 1 )*0.01),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = ability
						})	

end
