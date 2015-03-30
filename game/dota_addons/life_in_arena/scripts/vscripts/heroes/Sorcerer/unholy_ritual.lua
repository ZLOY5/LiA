function healing(caster, radius, healing_per_teak)

local table_target = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                                 caster:GetAbsOrigin(),
                                 nil,
                                 radius,
                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                 DOTA_UNIT_TARGET_ALL,
                                 DOTA_UNIT_TARGET_FLAG_NONE,
                                 FIND_ANY_ORDER,
                                 false) 


for _,unit in pairs(table_target) do

   if unit ~= caster then
   unit:SetHealth(unit:GetHealth()+unit:GetMaxHealth()*healing_per_teak )
   unit:SetMana(unit:GetMana()+unit:GetMaxMana()*healing_per_teak )                          
   end

end

return nil
end



function Director(keys)

local caster = keys.caster
local ability = keys.ability

local radius = keys.Radius
local barrier_reduction = keys.Barrier_reduction/100
local fee_per_teak = keys.Fee_per_teak/100
local healing_per_teak = keys.Healing_per_teak/100

healing(caster, radius, healing_per_teak)--Лечим 

caster:SetMana(caster:GetMana()-caster:GetMaxMana()*fee_per_teak )  --Уменьшаем ману

if caster:GetHealth()-caster:GetMaxHealth()*fee_per_teak > caster:GetMaxHealth()*barrier_reduction then       --Проверка уровня хп после уменьшения
  caster:SetHealth(caster:GetHealth()-caster:GetMaxHealth()*fee_per_teak ) 
else
caster:SetHealth(caster:GetMaxHealth()*barrier_reduction)
give_invulnerability(caster, radius, ability)
caster:RemoveModifierByName("unholy_ritual_datadriven")
ability:EndChannel(true)
end	


end


function give_invulnerability(caster, radius, ability)

local table_target = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                                 caster:GetAbsOrigin(),
                                 nil,
                                 radius,
                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                 DOTA_UNIT_TARGET_ALL,
                                 DOTA_UNIT_TARGET_FLAG_NONE,
                                 FIND_ANY_ORDER,
                                 false) 


for _,unit in pairs(table_target) do
ability:ApplyDataDrivenModifier(caster, unit, "modifier_invulnerability", {} )
end

return nil 
end
