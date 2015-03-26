function check_order( keys )
	local caster = keys.caster
	local ability = keys.ability
	

	ListenToGameEvent( "dota_player_used_ability", function( event )
			local ply = EntIndexToHScript( event.PlayerID )
			-- Check if player existed
			if ply then
				local hero = ply:GetAssignedHero()
				-- Check if it is corrent hero
				if hero == caster then
					-- Check if ability on cast bar is casted
					local ability_count = caster:GetAbilityCount()
					for i = 1, (ability_count - 1) do
						local ability_at_slot = caster:GetAbilityByIndex( i )
						if ability_at_slot ~= nil and ability_at_slot:GetAbilityName() == event.abilityname then 
						   ability:ApplyDataDrivenModifier(caster, caster, "modifier_inflicts", {duration = 0.03})
                                                   break
						end
					end
				end
			end
		end, nil
	)
end
