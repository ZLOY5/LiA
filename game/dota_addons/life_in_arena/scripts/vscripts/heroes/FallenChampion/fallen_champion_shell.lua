function shell(keys)
	local target = keys.caster
	local damagr = keys.Dmg
	if not target.alldmg then
		target.alldmg = 0
	end
	--if target.Barrier:IsNull() then
	if target.Barrier == nil then
		target.Barrier = true
	end
	--
	target.alldmg = target.alldmg + damagr
	if target.alldmg > target:GetMaxHealth() then
		if target.Barrier then
		--if not target:HasModifier('') then
			target.alldmg = target.alldmg - damagr
			--target.alldmg = target:GetMaxHealth()
		end
	end
--	CDebugOverlayScriptHelper:Text(target:GetAbsOrigin(),1,"ddwqwe",0.5,10,10,10,10,0.5)
end

function shell_cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local pr_damage = ability:GetSpecialValueFor("pr_damage")
	local radius = ability:GetSpecialValueFor("radius")
	local damage = 0.01*pr_damage*caster.alldmg
	--
	local targets = FindUnitsInRadius(caster:GetTeam(),caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage/2, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		ApplyDamage({victim = unit, attacker = caster, damage = damage/2, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
	end
	--
	caster.alldmg = 0

end

function shell_create(keys)
	local caster = keys.caster
	caster.alldmg = 0
	caster.alldmgActive = true
	--ApplyDamage({victim = caster, attacker = caster, damage = 100, damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})

end