LiA.bForceRoundEnabled = false

function onPlayerReadyToWave(playerID)
	if Survival.State == SURVIVAL_STATE_PRE_ROUND_TIME and LiA.bForceRoundEnabled then
		if not PlayerResource:IsReadyToRound(playerID) then
			PlayerResource:SetReadyToRound(playerID,true)
			if PlayerResource:GetNumPlayersReadyToRound() == LiA.nPlayers then
				Timers:RemoveTimer("StartRoundTimer")
				--timerPopup:SetTimeLeft(3)
				SetTimeLeft(3)
				Survival:StartRound()
			else
				local curTimeLeft = Survival.flRoundStartTime - GameRules:GetGameTime()
				local newTimeLeft =	curTimeLeft - 40 * ( 1 / LiA.nPlayers )	-- curTimeLeft * ( 1 - ( 1 / LiA.nPlayers ) )   --curTimeLeft - 60 * ( 1 / LiA.nPlayers )

				if curTimeLeft < 20 then
					return
				end
				
				if newTimeLeft < 20 then
					newTimeLeft = 20
				end
				
				print("Current time left: "..curTimeLeft,"New time left: "..newTimeLeft)

				--уменьшаем перезарядку способностей 
				local diff = curTimeLeft - newTimeLeft
				DoWithAllHeroes(
					function(hero)
						for i=1,4 do
							local ability = hero:GetAbilityByIndex(i)
							if ability then
								local cooldown = ability:GetCooldownTimeRemaining()
								if cooldown > 0 then
									local newCooldown = cooldown - diff
									if newCooldown > 0 then
										ability:StartCooldown(newCooldown)
									else
										ability:EndCooldown()
									end
								end
							end
						end
					end)
				--
			
				Survival.flRoundStartTime = GameRules:GetGameTime() + newTimeLeft
				Timers:RemoveTimer("StartRoundTimer")

			    Timers:CreateTimer("StartRoundTimer", 
			    	{ 
			    		endTime = newTimeLeft-3, 
			    		callback = function() Survival:StartRound() end
			    	})

			    SetTimeLeft(newTimeLeft)
			end
		end
	else
		FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "#lia_hud_error_cant_force_round" } )
	end
end
