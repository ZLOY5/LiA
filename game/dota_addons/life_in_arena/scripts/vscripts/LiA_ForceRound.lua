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
				local newTimeLeft = curTimeLeft * ( 1 - ( PlayerResource:GetNumPlayersReadyToRound() / LiA.nPlayers ) )
				
				if newTimeLeft < 15 then
					newTimeLeft = 15
				end
				
				print("Current time left: "..curTimeLeft,"New time left: "..newTimeLeft)
			
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
