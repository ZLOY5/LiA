function DealDamage( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local damage_to_deal = (caster:GetHealth()*ability:GetLevelSpecialValueFor("hp_damage_percentage", ability:GetLevel() - 1 )*0.01)
	for _,v in pairs(targets) do
			ApplyDamage({ victim = v, attacker = caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_PHYSICAL, ability = event.ability })
	end
end