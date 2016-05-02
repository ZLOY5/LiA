function StackCountIncrease(keys)
    local caster = keys.caster
    local ability = keys.ability
    local maxStack = keys.Stack
    local stackTime = ability:GetSpecialValueFor("stackTime")
    local attackGameTime = GameRules:GetGameTime()

    ability.lastExplosionTime = ability.lastExplosionTime or 0
    
    local currentStacks = caster:GetModifierStackCount("modifier_firerage_datadriven", caster)
    local addStacks = 1
    
    if keys.attacker:IsRealHero() or string.find(keys.attacker:GetUnitName(),"megaboss") then
        addStacks = 3
    end

    currentStacks = currentStacks + addStacks

    caster:SetModifierStackCount("modifier_firerage_datadriven", ability, currentStacks) 

    if currentStacks >= maxStack then 
        --print("boom")
        ability.lastExplosionTime = GameRules:GetGameTime()
        caster:SetModifierStackCount("modifier_firerage_datadriven", ability, 0) 
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_firerage_explosion", {duration = 0.03})

        local battleFevor = caster:FindAbilityByName("acron_battle_fevor")
        if battleFevor then
            battleFevor:OnExplosion()
        end
    end

    Timers:CreateTimer(stackTime,
        function() 
            if attackGameTime > ability.lastExplosionTime then
                local currentStacks = caster:GetModifierStackCount("modifier_firerage_datadriven", caster)
                if currentStacks ~= 0 then
                    caster:SetModifierStackCount("modifier_firerage_datadriven", ability, currentStacks-addStacks)
                end
            else
                --print("expiredStack")
            end
        end
    )
end
