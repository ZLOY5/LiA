function ApplyTrueHit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	
	if caster:PassivesDisabled() then return end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_4_wave_true_hit_damage", nil)
end

function DealDamageOrNot(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	target:EmitSound("Hero_TrollWarlord.BerserkersRage.Stun")
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end