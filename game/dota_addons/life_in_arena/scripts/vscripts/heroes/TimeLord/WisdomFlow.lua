function AddIntellect(keys)
	local caster = keys.caster	
	local ability = keys.ability
	
	ability:StartCooldown(ability:GetSpecialValueFor("stack_interval"))
	ability.cooldownStarted = true

	ability.currentStacks = ability.currentStacks+1

	caster:ModifyIntellect(1)
	caster:CalculateStatBonus(true)

	caster:SetModifierStackCount("modifier_time_lord_wisdom_flow", ability, ability.currentStacks)
end 

function CheckCooldown(keys)
	local caster = keys.caster	
	local ability = keys.ability

	if ability:IsCooldownReady() and ability.cooldownStarted then
		AddIntellect(keys)
	end
end




function StartCooldown(keys)
	local caster = keys.caster	
	local ability = keys.ability

	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	ability:StartCooldown(ability:GetSpecialValueFor("stack_interval"))
	ability.cooldownStarted = true

	caster:SetModifierStackCount("modifier_time_lord_wisdom_flow", ability, ability.currentStacks)
end


function StopCooldown(keys)
	keys.ability:EndCooldown()
	keys.ability.cooldownStarted = false
end
