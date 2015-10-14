function SDamage( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local koef_damage = ability:GetSpecialValueFor('koef_damage') 
	-- рассчитаем урон который необходимо нанести
	local intBase = caster:GetBaseIntellect()
	local intOther = caster:GetIntellect()-intBase
	local dmg = (intBase+intOther/2)*koef_damage
	--
	ApplyDamage({ victim = target, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })

end
