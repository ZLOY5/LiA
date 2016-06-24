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
			end
		end
	else
		FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "#lia_hud_error_cant_force_round" } )
	end
end
