Convars:RegisterCommand('player_say', function(...)
    local arg = {...}
    table.remove(arg,1)
    local sayType = arg[1]
    table.remove(arg,1)

    local cmdPlayer = Convars:GetCommandClient()
    keys = {}
    keys.ply = cmdPlayer
    keys.text = table.concat(arg, " ")

    if (sayType == 4) then
      -- Student messages
    elseif (sayType == 3) then
      -- Coach messages
    elseif (sayType == 2) then
      -- Team only
      -- Call your player_say function here like
      --self:PlayerSay(keys)
    else
      -- All chat
      -- Call your player_say function here like
      --self:PlayerSay(keys)
      if keys.text == "+" then
        onPlayerReadyToWave(cmdPlayer)
      end
      if keys.text == "KV_Update" then
        GameRules:Playtesting_UpdateAddOnKeyValues()
      end
      if keys.text == "-score" then
        if cmdPlayer:GetAssignedHero() then
          local hero = cmdPlayer:GetAssignedHero()
          Msg("Creeps:" .. hero.creeps .. " ; Bosses:" .. hero.bosses .. " ; Score:" .. hero.rating) --выводит в консоль
        end
      end
      if keys.text == "-pos" then
        print(cmdPlayer:GetAssignedHero():GetAbsOrigin())
      end
      --if keys.text == "-test" then
      --  local playerSteamID = PlayerResource:GetSteamAccountID(cmdPlayer:GetPlayerID())
      --  for _,SteamID in pairs(TEST_MODE_STEAM_ID) do 
      --    if playerSteamID == SteamID then
      --      LiA.TestMode = true
      --    end
      --  end
      --end
     --[[ if keys.text== "-givemegold" then 
        PlayerResource:ModifyGold(cmdPlayer:GetPlayerID(), 9999, false, 0)
      end]]
    end
  end, 'player say', 0)