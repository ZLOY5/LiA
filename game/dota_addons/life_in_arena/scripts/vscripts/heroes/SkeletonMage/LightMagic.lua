function DealDamageAndHeal( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities
	for _,v in pairs(targets) do
		local maxHP = v:GetMaxHealth()
		if v:GetTeamNumber() ~= caster:GetTeamNumber() then
			local dmgPerc = ability:GetLevelSpecialValueFor("damage_percentage", ability:GetLevel() - 1 )
			local dmgConst = ability:GetLevelSpecialValueFor("damage_constant", ability:GetLevel() - 1 )
			local dmgAll = (maxHP*dmgPerc*0.01 + dmgConst)
			ApplyDamage({ victim = v, attacker = caster, damage = dmgAll, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })
		else
			local healPerc = ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1)
			local healConst = ability:GetLevelSpecialValueFor("heal_constant", ability:GetLevel() - 1 )
			local healAll = maxHP*healPerc*0.01 + healConst
			v:Heal(healAll, caster)	
		end

	end

end