function Finde_and_apply(keys)

local ability = keys.ability
local caster = keys.caster	

-- Find all units
Units = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                               DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)



for _,unit in pairs(Units) do
  if unit ~= caster then
    if unit:IsRealHero() then
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_lock_stun_datadriven", {duration = keys.Sran_hero})    --0.03
    else
    ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_lock_stun_datadriven", {duration = keys.Stan_ather})
    end
  end
end


end
