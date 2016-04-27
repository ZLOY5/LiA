function StackCountIncrease(keys)
    local caster = keys.caster
    local ability = keys.ability
    local currentStacks = caster:GetModifierStackCount("modifier_firerage_datadriven", caster)
    local maxStack = keys.Stack
    
    currentStacks = currentStacks + 1

    keys.caster:SetModifierStackCount("modifier_firerage_datadriven", keys.ability, currentStacks) 

    if currentStacks == maxStack then 
        keys.caster:SetModifierStackCount("modifier_firerage_datadriven", keys.ability, 0) 
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_firerage_explosion", {duration = 0.03})
    end
end

function StackCountDecrease(keys)
    local currentStacks = caster:GetModifierStackCount("modifier_firerage_datadriven", caster)
    if currentStacks ~= 0 then
        keys.caster:SetModifierStackCount("modifier_firerage_datadriven", keys.ability, currentStacks-1) 
    end
end
