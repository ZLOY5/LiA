function AddIntellect(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	ability:StartCooldown(ability:GetSpecialValueFor("stack_interval"))

	ability.currentStacks = ability.currentStacks+keys.bonus_intellect

	caster:ModifyIntellect(keys.bonus_intellect)
	caster:CalculateStatBonus()

	caster:SetModifierStackCount("modifier_time_lord_wisdom_flow", ability, ability.currentStacks)
end 



function StartCooldown(keys)
	local caster = keys.caster	
	local ability = keys.ability

	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	ability:StartCooldown(ability:GetSpecialValueFor("stack_interval"))

	caster:SetModifierStackCount("modifier_time_lord_wisdom_flow", ability, ability.currentStacks)
end


function StopCooldown(keys)
	keys.ability:EndCooldown()
end
