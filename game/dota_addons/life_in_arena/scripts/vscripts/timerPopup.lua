function StartTimer(time,timerType,waveNum)

    timeStart = GameRules:GetDOTATime(false,false)
    timeEnd = GameRules:GetDOTATime(false,false) + time --Time to Finish the quest
    timerTypeSaved = timerType
    waveNumSaved = waveNum

    CustomNetTables:SetTableValue("lia_player_table", "lia_timer", 
        {
            startTime = timeStart, 
            endTime = timeEnd, 
            timerType = timerType,
            wave = waveNum
        })
end

function SetTimeLeft(newTimeLeft)
    --print(timeStart+newTimeLeft)
    CustomNetTables:SetTableValue("lia_player_table", "lia_timer", 
        {
            startTime = timeStart, 
            endTime = GameRules:GetDOTATime(false,false)+newTimeLeft, 
            timerType = timerTypeSaved,
            wave = waveNumSaved
        })
end


function StopTimer()
    CustomGameEventManager:Send_ServerToAllClients("lia_timer_stop", nil)
end
