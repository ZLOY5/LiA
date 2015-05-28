

function check_order( keys )
	local caster = keys.caster
	local ability = keys.ability
	ListenToGameEvent( 'dota_player_used_ability',
		function(_, event)
			local pl = EntIndexToHScript( event.PlayerID )
			if pl then
				local hero = pl:GetAssignedHero()
				if hero == caster then
					local findAbility = hero:FindAbilityByName( event.abilityname )
					if (caster == hero) and ( findAbility:GetClassname() == 'ability_datadriven') then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_inflicts", {duration = 0.03})
					end
				end
			end
		end
	, {})
	--ListenToGameEvent( 'dota_player_used_ability', ApplyCooldownReduction, {})
end