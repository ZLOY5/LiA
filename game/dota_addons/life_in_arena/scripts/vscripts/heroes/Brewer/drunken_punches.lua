function Return(event)
local caster = event.caster
local attacker = event.attacker
local damageType = event.ability:GetAbilityDamageType()
local casterSTR = caster:GetStrength()
local return_damage = casterSTR*event.Coefficient 

if caster:PassivesDisabled() then
	return
end

local damage_table = { 
  attacker = caster,
	damage_type = damageType, 
	damage = return_damage,
	ability = event.ability,
	victim = attacker,
}
	

ApplyDamage(damage_table)

end 
