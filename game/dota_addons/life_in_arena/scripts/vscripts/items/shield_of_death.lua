function ApplyArmor(event)
	event.caster:AddNewModifier(event.caster,event.ability,"modifier_item_shield_of_death_armor",{duration = event.ability:GetSpecialValueFor("duration")})
end