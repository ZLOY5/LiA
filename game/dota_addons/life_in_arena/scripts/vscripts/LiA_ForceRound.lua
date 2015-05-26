
nPlayersReady = 0

function onPlayerReadyToWave(player)
	if IsPreWaveTime then
		if not player.readyToWave then
			player.readyToWave = true
			nPlayersReady = nPlayersReady + 1
			if nPlayersReady == nPlayers then
				ForceRound()
			end
		end
	else
		FireGameEvent( 'custom_error_show', { player_ID = player:GetPlayerID(), _error = "#lia_hud_error_cant_force_round" } )
	end
end

function ForceRound() 
	nPlayersReady = 0
	for _,player in pairs(tPlayersTop) do
		player.readyToWave = false
	end
	Timers:RemoveTimer("preWaveMessageTimer")
	Timers:RemoveTimer("preWaveTimer")
	IsPreWaveTime = false
	if WAVE_NUM % 5 == 0 then --мегабоссы
		Timers:CreateTimer("preWaveTimer",{ endTime = 3, callback = function() LiA.SpawnMegaboss() return nil end})
        if WAVE_NUM == 20 then
            message = "#lia_finalboss"
        else
            message = "#lia_megaboss"
        end
        timerPopup:Start(3,message,0)
        ShowCenterMessage(message,5)
    else --обычные волны
        Timers:CreateTimer("preWaveTimer",{ endTime = 3, callback = function() LiA.SpawnWave() return nil end})
        message = "#lia_wave_num"
        timerPopup:Start(3,"#lia_wave_num",WAVE_NUM)
        ShowCenterMessage(message,5,WAVE_NUM)
    end
end