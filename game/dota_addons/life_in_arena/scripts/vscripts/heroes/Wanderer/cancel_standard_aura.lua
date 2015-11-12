function cancel(keys)
	--
	local ability = keys.ability
	local caster = keys.caster --hero
	local modif = caster:FindModifierByName("modifier_silencer_int_steal")
	--print(modif)
	--print(caster:HasModifier("modifier_silencer_int_steal"))
	
	caster:RemoveModifierByName("modifier_silencer_int_steal")
	--print("			caster:RemoveModifierByName")
end