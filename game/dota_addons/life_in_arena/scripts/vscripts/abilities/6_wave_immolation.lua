--[[
Based on Noya's Immolation for DotaCraft
https://github.com/MNoya/DotaCraft/blob/master/scripts/npc/abilities/demon_hunter_immolation.txt
]]
function Immolation( event )
	local caster = event.caster
	local ability = event.ability
	local targets = event.target_entities

	local abilityDamageType = ability:GetAbilityDamageType()
	local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1 )
	local manacost_per_second = ability:GetLevelSpecialValueFor("mana_cost_per_second", ability:GetLevel() - 1 )
	
	-- Check if the spell mana cost can be maintained
	if caster:GetMana() >= manacost_per_second then
		caster:SpendMana( manacost_per_second, ability)

		-- Deal damage to all targets passed
		for _,v in pairs(targets) do
			ApplyDamage({ victim = v, attacker = caster, damage = damage_per_second, damage_type = abilityDamageType, ability = ability })
		end
	else
		ability:ToggleAbility()
	end
end