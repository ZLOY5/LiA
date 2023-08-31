function FrostNova(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local targets = event.target_entities
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Ability.FrostNova")
	ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetSpecialValueFor("aoe_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	for _,v in pairs(targets) do
		ApplyDamage({victim = v, attacker = caster, damage = ability:GetSpecialValueFor("aoe_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		ability:ApplyDataDrivenModifier(caster, v, "modifier_9_wave_frost_nova_slow", {duration = ability:GetSpecialValueFor("slow_hero_duration")})
	end
end