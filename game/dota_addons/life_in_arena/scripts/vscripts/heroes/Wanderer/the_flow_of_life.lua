function HealMana(keys)
	--
	--local ability = keys.ability
	--local caster = keys.caster --hero
	local unit = keys.target
	local amount = keys.amount
	--local count = keys.count

	
	unit:GiveMana(amount)
	--unit:ReduceMana(amount)
end