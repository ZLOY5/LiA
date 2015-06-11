
function stormCauseDamage(keys)

	--local heroCaster = keys.heroCaster
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = keys.damage

	--DebugDrawText(caster:GetAbsOrigin(), "1", true, 4)	
	--caster:ReduceMana(1000)

	if caster:HasModifier('modifier_warlock_storm_hero') then
		ApplyDamage(
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end

end