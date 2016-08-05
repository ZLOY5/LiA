function StartTimer(time,title,waveNum)
  entQuest = SpawnEntityFromTableSynchronous( "quest", { name = "Quest", title = title } )
  --add   "QuestTimer"  "Survive for %quest_current_value% seconds"   in addon_english
  questTimeStart = GameRules:GetGameTime()
  questTimeEnd = GameRules:GetGameTime() + time --Time to Finish the quest

  --bar system
  entKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
    show_progress_bar = true,
    progress_bar_hue_shift = -119
  } )
  entQuest:AddSubquest( entKillCountSubquest )
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, time ) --text on the quest timer at start
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, waveNum ) --text on the quest timer
  entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, time ) --value on the bar at start
  entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, time ) --value on the bar
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, waveNum )
    Timers:CreateTimer(0.5, function()
        entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() ) --update the bar with the time passed        
        entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, waveNum )
        entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, questTimeEnd - GameRules:GetGameTime() )
        if (questTimeEnd - GameRules:GetGameTime())<=1 then
          --EmitGlobalSound("Tutorial.Quest.complete_01") --on game_sounds_music_tutorial, check others
          UTIL_RemoveImmediate( entQuest )
          entKillCountSubquest = nil
          return nil
        end
        return 1      
    end
    )
  
end

function SetTimeLeft(time)
  questTimeEnd = GameRules:GetGameTime() + time
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, questTimeEnd - GameRules:GetGameTime() )
end

function StopTimer()
   questTimeEnd = GameRules:GetGameTime() 
end