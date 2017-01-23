function OnSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targets = event.target_entities
	local unitCount = 0
	local initial_damage = ability:GetSpecialValueFor("initial_damage")
	
	for _,v in pairs(targets) do
		unitCount = unitCount + 1
	end

	local duration = ability:GetSpecialValueFor("initial_duration") + ability:GetSpecialValueFor("additional_duration") * unitCount

	for _,v in pairs(targets) do
		if v:FindModifierByNameAndCaster("modifier_demonologist_demonic_seal", caster) == nil then
			v.demonicSealDamageToDeal = initial_damage
		end
		ApplyDamage({victim = v, attacker = caster, damage = v.demonicSealDamageToDeal, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		ability:ApplyDataDrivenModifier(caster,v,"modifier_demonologist_demonic_seal",{duration = duration})
	end
	
end

function OnIntervalThink(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local additional_damage = ability:GetSpecialValueFor("additional_damage")

	target.demonicSealDamageToDeal = target.demonicSealDamageToDeal + additional_damage
	ApplyDamage({victim = target, attacker = caster, damage = target.demonicSealDamageToDeal, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end