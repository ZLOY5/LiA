
function StackAddAgility(keys)

    	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability

	if not ability.damageStack then
		ability.damageStack = 0
	end

	--
    	local maxStack = keys.maxStack
    
	if unit:IsIllusion() == false and unit:GetTeamNumber() ~= caster:GetTeamNumber() then
    		ability.damageStack = ability.damageStack + 1
	end
	--
	--
    	if ability.damageStack >= maxStack then 
		ability.damageStack = 0
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_resourcefulness_add_agility", nil)
		caster:ReduceMana(1000)
	end	
	--

end