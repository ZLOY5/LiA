function DealDamageAndHeal( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage 
	local heal= event.heal
	--
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	else
		target:Heal(heal, caster)	
	end

end