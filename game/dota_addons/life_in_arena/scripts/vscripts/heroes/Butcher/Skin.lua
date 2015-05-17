function MegabossReturn(event)
	if event.target == event.caster and event.target:HasModifier("empty_modifier_return_butcher") then
		ApplyDamage(
		{
			victim = event.attacker,
			attacker = event.caster,
			damage = event.damage_return*event.attack_damage*0.01,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
end