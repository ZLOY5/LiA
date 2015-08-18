function SummonSpirit(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("lifetime")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220

    local hero_hp = caster:GetMaxHealth()
    local hero_mp = caster:GetMaxMana()

    local unit = CreateUnitByName("keeper_of_the_grove_guardian_spirit", front_position, true, caster, caster, caster:GetTeam())
    unit:SetBaseMaxHealth(1112)
   -- unit:SetHealth(hero_hp)
    unit:SetMana(hero_mp)
    unit:SetControllableByPlayer(playerID, false)
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
end