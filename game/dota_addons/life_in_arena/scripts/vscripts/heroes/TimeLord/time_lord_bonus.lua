function information_of_spell(keys)

local caster = keys.caster	
local ability = keys.ability
local level = ability:GetLevel() - 1
local cooldown = ability:GetCooldown(level)

local modifier_name = "modifier_time_lord_supporting_of_time_datadriven"
-- Get the current stack count
local current_stack = caster:GetModifierStackCount(modifier_name, ability)

ability:StartCooldown(cooldown)



    if not ability.currentStacks then
       ability.currentStacks = 0 
    end

 ability.currentStacks = ability.currentStacks+keys.Bonus

print(ability.currentStacks)
print("bonus",keys.Bonus)

caster:SetModifierStackCount(modifier_name, ability, ability.currentStacks)



end 



function start_cooldawn_after_respawn(keys)

local caster = keys.caster	
local ability = keys.ability
local level = ability:GetLevel() - 1
local cooldown = ability:GetCooldown(level)

local modifier_name = "modifier_time_lord_supporting_of_time_datadriven"

ability:StartCooldown(cooldown)

caster:SetModifierStackCount(modifier_name, ability, ability.currentStacks)

end


function stop_cooldawn(keys)

local ability = keys.ability

ability:EndCooldown()

end
