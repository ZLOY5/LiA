function Heal(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targets = event.target_entities
	local heal = target:GetMaxHealth()*ability:GetSpecialValueFor("value_heal_percent")*0.01

	for _,v in pairs(targets) do
			v:Heal(heal, ability)
	end 
end