function StormBolt(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:IsMagicImmune() then
		return 
	elseif target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")
	ApplyDamage({victim = target, attacker = caster, damage = ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_stunned", {duration = ability:GetSpecialValueFor("duration")})
end