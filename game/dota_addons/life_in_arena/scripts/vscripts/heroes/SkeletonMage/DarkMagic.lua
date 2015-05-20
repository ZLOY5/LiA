function Return(event)
	if event.target == event.caster and event.target:HasModifier("modifier_skeleton_mage_dark_magic") then
		ApplyDamage(
		{
			victim = event.attacker,
			attacker = event.caster,
			damage = event.damage_return,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
end