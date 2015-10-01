function DealDamage( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local damage = event.Damage
	local secondary_damage = (target:GetMaxHealth()*ability:GetLevelSpecialValueFor("secondary_target_percent", ability:GetLevel() - 1 )*0.01)
	local primary_damage = (target:GetHealth()*ability:GetLevelSpecialValueFor("main_target_percent", ability:GetLevel() - 1 )*0.01)
	for _,v in pairs(targets) do
		if v ~= target then
			ApplyDamage({ victim = v, attacker = caster, damage = secondary_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
			else
			ApplyDamage({ victim = v, attacker = caster, damage = primary_damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })	
			
		end
	end
end