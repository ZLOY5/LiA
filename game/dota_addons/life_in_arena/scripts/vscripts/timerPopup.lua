function StartTimer(time,timerType,waveNum)

    timeStart = GameRules:GetDOTATime(false,false)
    timeEnd = GameRules:GetDOTATime(false,false) + time --Time to Finish the quest
    timerTypeSaved = timerType
    waveNumSaved = waveNum

    CustomGameEventManager:Send_ServerToAllClients("lia_timer_start", 
        {
            startTime = timeStart, 
            endTime = timeEnd, 
            timerType = timerType,
            wave = waveNum
        })
end

function SetTimeLeft(newTimeLeft)
    --print(timeStart+newTimeLeft)
    CustomGameEventManager:Send_ServerToAllClients("lia_timer_time_left", 
        {
            endTime = GameRules:GetDOTATime(false,false)+newTimeLeft, 
        })
end


function StopTimer()
    CustomGameEventManager:Send_ServerToAllClients("lia_timer_stop", nil)
end

function ReconnectTimer(playerID)
    if timeEnd and timeEnd > GameRules:GetDOTATime(false,false) then
        CustomGameEventManager:Send_ServerToAllClients("lia_timer_start", 
            {
                startTime = timeStart, 
                endTime = timeEnd, 
                timerType = timerTypeSaved,
                wave = waveNumSaved
            })
    end
end