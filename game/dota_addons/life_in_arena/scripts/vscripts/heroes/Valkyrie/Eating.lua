function Heal( event )
	local caster = event.caster
	local ability = event.ability
  	local target = event.target
	local targets = event.target_entities
	local heal = target:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01
			caster:Heal(target:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01, event.target)	
end