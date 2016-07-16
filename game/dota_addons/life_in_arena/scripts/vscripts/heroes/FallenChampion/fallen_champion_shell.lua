function shell_create(keys)
	keys.caster.accumDamage = 0
end

function shell(keys)
	local caster = keys.caster
	
	if not caster.accumDamage then
		caster.accumDamage = 0
	end

	local lastAccumDamage = caster.accumDamage
	local bOverMaxHP = caster.accumDamage > caster:GetMaxHealth()

	caster.accumDamage = caster.accumDamage + keys.Dmg

	if not caster:HasModifier("modifier_fallen_champion_roar_hero") and caster.accumDamage > caster:GetMaxHealth() then 
		if bOverMaxHP then
			caster.accumDamage = lastAccumDamage
		else
			caster.accumDamage = caster:GetMaxHealth()
		end
	end

end

function OnIntervalThink(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_fallen_champion_roar_hero") and caster.accumDamage > caster:GetMaxHealth() then
		caster.accumDamage = caster.accumDamage - (caster.accumDamage/caster:GetMaxHealth())
	end
end



function shell_cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local pr_damage = ability:GetSpecialValueFor("pr_damage")
	local radius = ability:GetSpecialValueFor("radius")
	local damage = 0.01*pr_damage*caster.accumDamage/2
	--
	local targets = keys.target_entities
	
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
	end
	--
	caster.accumDamage = 0

end

