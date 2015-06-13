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
      if keys.text == "1" then
        local u = CreateUnitByName("orn_mutant", Vector(0,0,0), true, nil, nil, DOTA_TEAM_GOODGUYS)
        print("Base attack time: ",u:GetBaseAttackTime())
        print("Attack Speed: ",u:GetAttackSpeed())
        print("Increased attack Speed: ",u:GetIncreasedAttackSpeed())
        print("Seconds per attack: ",u:GetSecondsPerAttack())
      end
    end
  end, 'player say', 0)