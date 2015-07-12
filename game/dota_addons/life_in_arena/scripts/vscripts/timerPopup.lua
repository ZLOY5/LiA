--timerPopup


if timerPopup == nil then
  timerPopup = {}
end

function timerPopup:Start(time,title,waveNum)
  timerPopup.timeLeft = time
  timerPopup.title = title
  timerPopup.waveNum = waveNum
  FireGameEvent('lia_timer_popup_start', { time = time, title = title, waveNum = waveNum }) 
  Timers:CreateTimer("timerPopup", {
    useGameTime = true,
    endTime = 1,
    callback = function()
      timerPopup.timeLeft = timerPopup.timeLeft - 1
      FireGameEvent('lia_timer_popup_tick', { time = timerPopup.timeLeft}) 
      if timerPopup.timeLeft <= 0 then
        FireGameEvent('lia_timer_popup_end',{}) 
        return nil
      end
      return 1
    end
  })
end

function timerPopup:SetTimeLeft(timeleft)
  timerPopup:Start(timeleft,timerPopup.title,timerPopup.waveNum)
end

function timerPopup:Stop()
  FireGameEvent('lia_timer_popup_end',{}) 
  Timers:RemoveTimer("timerPopup")
end