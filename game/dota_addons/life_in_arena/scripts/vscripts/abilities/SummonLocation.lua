function SummonLocation( event )
    local caster = event.caster
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 250

    local result = {}
    table.insert(result, front_position)

    return result
end