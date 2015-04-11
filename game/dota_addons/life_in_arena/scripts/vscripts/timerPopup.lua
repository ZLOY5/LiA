--timerPopup

local timeLeft

if timerPopup == nil then
  timerPopup = {}
end

function timerPopup:Start(time,title,waveNum)
  timeLeft = time
  FireGameEvent('lia_timer_popup_start', { time = time, title = title, waveNum = WAVE_NUM }) 
  Timers:CreateTimer(1, function()
      timeLeft = timeLeft - 1
      FireGameEvent('lia_timer_popup_tick', { time = timeLeft}) 
      if timeLeft == 0 then
        FireGameEvent('lia_timer_popup_end',{}) 
        return nil
      end
      return 1
    end)
end

function timerPopup:Stop()
  FireGameEvent('lia_timer_popup_end',{}) 
end