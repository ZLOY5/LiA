function LifeDrainFirstInstance(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local damage = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1)


	--print(caster.thirst_points or 0)
	life_drain_damage = damage + (caster.thirst_points or 0)*2

	if caster.thirst_points then
		caster.thirst_points = 0
	end
	local modifier = caster:FindModifierByName("modifier_vampire_lifesteal")
	if modifier then
		modifier:SetStackCount(0)
	end

	for _,v in pairs(targets) do
		ApplyDamage({ victim = v, attacker = caster, damage = life_drain_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		caster:Heal(life_drain_damage, caster)	
	end
end

function LifeDrain(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities

	for _,v in pairs(targets) do
		ApplyDamage({ victim = v, attacker = caster, damage = life_drain_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		caster:Heal(life_drain_damage, caster)	
	end
end