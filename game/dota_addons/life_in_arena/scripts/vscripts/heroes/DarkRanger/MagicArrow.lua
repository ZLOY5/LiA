function MagicArrow(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targets = event.target_entities

	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_ranger_magic_arrow_main_target", nil)
	for _,unit in pairs(targets) do 
		if unit ~= target then
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_dark_ranger_magic_arrow_all_target", nil)
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