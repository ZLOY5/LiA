
nPlayersReady = 0

function onPlayerReadyToWave(player)
	if Survival.State == SURVIVAL_STATE_PRE_ROUND_TIME then
		if not player.readyToWave then
			player.readyToWave = true
			nPlayersReady = nPlayersReady + 1
			if nPlayersReady == LiA.nPlayers then
				Timers:RemoveTimer("StartRoundTimer")
				timerPopup:SetTimeLeft(3)
				Survival:StartRound()
			end
		end
	else
		FireGameEvent( 'custom_error_show', { player_ID = player:GetPlayerID(), _error = "#lia_hud_error_cant_force_round" } )
	end
end
