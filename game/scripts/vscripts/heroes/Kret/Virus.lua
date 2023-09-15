function Virus(event)
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities
	local target = event.target
	
	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_kret_virus_main_target", nil)
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetSpecialValueFor("main_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	for _,unit in pairs(targets) do 
		if unit ~= target then
			ApplyDamage({victim = unit, attacker = caster, damage = ability:GetSpecialValueFor("other_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end