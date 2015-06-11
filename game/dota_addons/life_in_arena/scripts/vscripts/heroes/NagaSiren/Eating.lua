function Heal( event )
	local ability = event.ability
  	event.caster:Heal(event.unit:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01, event.unit)	
end