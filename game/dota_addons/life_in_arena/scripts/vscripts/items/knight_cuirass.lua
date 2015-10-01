function OnAttackLanded(event)
	if event.target == event.caster and event.target:HasItemInInventory("item_lia_knight_cuirass") then
		ApplyDamage(
		{
			victim = event.attacker,
			attacker = event.caster,
			damage = event.damage_return*event.attack_damage*0.01,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = event.ability
		})
	end
end
