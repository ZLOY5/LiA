function AddArmor(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()-1
	local maxStack = ability:GetLevelSpecialValueFor("max_armor", level)/ability:GetLevelSpecialValueFor("armor_per_attack", level)
	
	if not ability.armorStack then
		ability.armorStack = 0
	end

	if ability.armorStack < maxStack then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_improved_armor_stackable", nil)
		ability.armorStack = ability.armorStack + 1 
	end
end

function DecrementStack(event)
	local ability = event.ability
	ability.armorStack = ability.armorStack - 1
end