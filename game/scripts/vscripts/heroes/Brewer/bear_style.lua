function CheckingMain(keys)
local caster = keys.caster

--Get all unit in radius on table
local table_target = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                                 caster:GetAbsOrigin(),
                                 nil,
                                 keys.DetectionRadius,
                                 DOTA_UNIT_TARGET_TEAM_BOTH,
                                 DOTA_UNIT_TARGET_ALL,
                                 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                 FIND_ANY_ORDER,
                                 false) 


local counts_target = #table_target - 1

--Set count
keys.caster:SetModifierStackCount("bear_style_datadriven", keys.ability, counts_target*keys.Strength) 


local modifierCount = caster:GetModifierCount()
local currentStack  = 0

-- Counts the current stacks
	for i = 0, modifierCount do
		modifierName = caster:GetModifierNameByIndex(i)

		if modifierName == "bonus_strength" then
			currentStack = currentStack + 1
		end
	end


  --Add modifier or removing
  if counts_target - currentStack > 0 then
      for i = 1, (counts_target - currentStack)  do
      keys.ability:ApplyDataDrivenModifier(caster, caster, "bonus_strength", {})
      print("Current number: " .. i)
      end
  elseif counts_target - currentStack < 0 then
      for i = 1, math.abs(counts_target - currentStack)  do
      keys.caster:RemoveModifierByName("bonus_strength")
      print("Remoned number: " .. i)
      end
  end

end



function CheckinLvlup(keys)
local caster = keys.caster


local modifierCount = caster:GetModifierCount()
local currentStack  = 0

-- Counts the current stacks
	for i = 0, modifierCount do
		modifierName = caster:GetModifierNameByIndex(i)

		if modifierName == "bonus_strength" then
			currentStack = currentStack + 1
		end
	end

-- Remove all old modifier
    for i = 1, currentStack  do
    keys.caster:RemoveModifierByName("bonus_strength")
    print("Remoned number: " .. i)
    end
--Add new modifier
    for i = 1, currentStack  do
    keys.ability:ApplyDataDrivenModifier(caster, caster, "bonus_strength", {})
    print("Current number: " .. i)
    end

end
