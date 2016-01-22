function cancel(keys)
	local caster = keys.caster --hero

	--print(caster:HasModifier("modifier_silencer_int_steal"))
	
	caster:RemoveModifierByName("modifier_silencer_int_steal")
end