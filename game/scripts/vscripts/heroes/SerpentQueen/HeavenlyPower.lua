function AddAgility(event)
	local bonusAgility = event.ability:GetSpecialValueFor("bonus_agility")
	event.caster:ModifyAgility(bonusAgility)
	event.ability.bonusAgility = bonusAgility
end

function RemoveAgility(event)
	event.caster:ModifyAgility(-event.ability.bonusAgility) 
end