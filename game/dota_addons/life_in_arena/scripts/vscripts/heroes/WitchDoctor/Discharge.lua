function Discharge( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	local emp_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	for _,v in pairs(targets) do
		if v:GetTeamNumber() ~= caster:GetTeamNumber() then
			local dmg = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
			ApplyDamage({ victim = v, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
		else
			local heal = ability:GetLevelSpecialValueFor("heal", ability:GetLevel() - 1 )
			v:Heal(heal, caster)	
		end

	end
	ParticleManager:DestroyParticle(emp_effect, false)
end