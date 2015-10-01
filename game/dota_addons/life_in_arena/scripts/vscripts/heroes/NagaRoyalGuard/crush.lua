--[[
Based on Noya's Immolation for DotaCraft
https://github.com/MNoya/DotaCraft/blob/master/scripts/npc/abilities/demon_hunter_immolation.txt
]]
function Immolation( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local abilityDamageType = ability:GetAbilityDamageType()
	local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1 )
	local strength = caster:GetStrength()
	local targets = event.target_entities


		-- Deal damage to all targets passed
		for _,v in pairs(targets) do
			ApplyDamage({ victim = v, attacker = caster, damage = ((damage_per_second + strength)/4), damage_type = abilityDamageType, ability = ability })
		end

end