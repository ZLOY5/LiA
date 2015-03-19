function StackCountIncrease(keys)
    
    local caster = keys.caster
    local ability = keys.ability
    local currentStacks = caster:GetModifierStackCount("modifier_firerage_datadriven", caster)
    local maxStack = keys.Stack
    
    currentStacks = currentStacks + 1

    keys.caster:SetModifierStackCount("modifier_firerage_datadriven", keys.ability, (currentStacks)) 

    if currentStacks == maxStack then 
       caster:RemoveModifierByName("modifier_firerage_datadriven") 
       ability:ApplyDataDrivenModifier( caster, caster, "modifier_firerage_datadriven", {})
       ability:ApplyDataDrivenModifier( caster, caster, "modifier_firerage_explosion", {duration = 0.03})
    end

end
