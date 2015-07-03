
function electRegen(keys)

	local target = keys.target
	local ability = keys.ability
	local value_regen = keys.value_regen
	local tick = keys.tick
	--
	local value1perc = target:GetMaxHealth() / 100	
	local reg 
	--
	if ability:GetLevel()-1 == 0 then
		reg = value_regen * tick
	else
		reg = value1perc * value_regen * tick
	end
	--
	target:Heal(reg,keys.caster)

end
