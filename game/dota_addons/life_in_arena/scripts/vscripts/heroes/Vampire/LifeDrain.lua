function LifeDrainFirstInstance(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local damage = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1)

	if not caster:HasModifier("modifier_vampire_lifesteal") then
		thirst_points_life_drain = 0
	else
		thirst_points_life_drain = thirst_points
		thirst_points = 0
		caster:SetModifierStackCount("modifier_vampire_lifesteal", caster, thirst_points)
	end
		life_drain_damage = damage + thirst_points_life_drain*2


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