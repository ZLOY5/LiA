function OnAttackLanded(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local target_damage = caster.agility*ability:GetSpecialValueFor("damage_agility_percent")*0.01
	local damage = ability:GetSpecialValueFor("damage")

	local modStealShadow = target:FindModifierByName("modifier_steal_shadow")
	if modStealShadow then 
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = target_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		}

		ApplyDamage(damageTable)

		damageTable.damage = damage

		local abiStealShadow = modStealShadow:GetAbility()
		for _,unit in pairs(abiStealShadow.targets) do
			if IsValidEntity(unit) and unit:HasModifier("modifier_steal_shadow") then 
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
		end
	end


end