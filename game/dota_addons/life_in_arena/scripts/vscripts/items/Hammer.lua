function Bash(event)
	if event.caster:IsIllusion() then
		return 
	end

	local ability = event.ability

	local damageTable = {
						 	victim = event.target, 
						 	attacker = event.caster, 
						 	damage = ability:GetSpecialValueFor("bash_damage"), 
						 	damage_type = DAMAGE_TYPE_MAGICAL,
						 	ability = ability
						}

	ApplyDamage(damageTable)
	event.target:AddNewModifier(event.caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
	event.target:EmitSound("DOTA_Item.MKB.Minibash")
end