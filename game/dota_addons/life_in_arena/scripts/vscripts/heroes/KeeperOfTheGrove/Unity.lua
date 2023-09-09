function Unity(event)
	local caster = event.caster
	local owner = caster:GetOwnerEntity()
	local heal = caster:GetHealth()

	owner:Heal(heal, caster)
	caster:Kill(event.ability, caster)
end