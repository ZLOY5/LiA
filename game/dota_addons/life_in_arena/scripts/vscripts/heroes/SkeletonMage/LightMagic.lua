function DealDamage( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	for _,v in pairs(targets) do
			ApplyDamage({ victim = v, attacker = caster, damage = (v:GetMaxHealth()*ability:GetLevelSpecialValueFor("damage_percentage", ability:GetLevel() - 1 )*0.01 + ability:GetLevelSpecialValueFor("damage_constant", ability:GetLevel() - 1 )), damage_type = DAMAGE_TYPE_PHYSICAL })	
		end

end


function Heal( event )
	local caster = event.caster
	local ability = event.ability
  	local target = event.target
	local targets = event.target_entities
	for _,v in pairs(targets) do
			v:Heal((v:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01 + ability:GetLevelSpecialValueFor("heal_constant", ability:GetLevel() - 1 )), event.caster)	
		end
end
