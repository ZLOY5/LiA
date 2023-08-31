function Acid(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities
	local target = event.target
	
	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_kret_acid_main_target", nil)

	for _,unit in pairs(targets) do 
		if unit ~= target then
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_kret_acid_all_target", nil)
		end
	end
end

function Damage(event)
	local unit = event.target
	local damage = event.ability:GetSpecialValueFor("main_damage") / event.ability:GetSpecialValueFor("duration") / 2
	ApplyDamage({victim = unit, attacker = event.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability})
end

function DamageOther(event)
	local unit = event.target
	local damage = event.ability:GetSpecialValueFor("other_damage") / event.ability:GetSpecialValueFor("duration") / 2
	ApplyDamage({victim = unit, attacker = event.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability})
end