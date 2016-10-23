LinkLuaModifier("modifier_guardian_spirit",  "heroes/KeeperOfTheGrove/modifier_guardian_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function SummonSpirit(event)
	local caster = event.caster
    local ability = event.ability
	local playerID = caster:GetPlayerID()
	local duration = ability:GetSpecialValueFor("lifetime")
    local bonusStats = ability:GetSpecialValueFor("bonus_stats")

	local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    
    local front_position = origin + fv * 220

    local unit = CreateUnitByName("keeper_of_the_grove_guardian_spirit", front_position, true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)

    ResolveNPCPositions(unit:GetAbsOrigin(),65)

    --unit:AddAbility("keeper_of_the_grove_guardian_spirit_narure_forces")
    unit:FindAbilityByName("keeper_of_the_grove_guardian_spirit_narure_forces"):SetLevel(ability:GetLevel())
    
    local agility = caster:GetAgility() + bonusStats
    local strength = caster:GetStrength() + bonusStats
    local intellect = caster:GetIntellect() + bonusStats

    local healthBonus = strength * HERO_STATS_HEALTH_BONUS
    local armorBonus = agility * HERO_STATS_ARMOR_BONUS
    unit:SetMaxHealth(unit:GetMaxHealth()+healthBonus)
    unit:SetHealth(unit:GetMaxHealth()+healthBonus)
    unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()+armorBonus)
    unit:AddNewModifier(caster, ability, "modifier_guardian_spirit", {agility = agility, strength = strength, intellect = intellect})
    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})    
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_status_effect_spirit", nil)
end