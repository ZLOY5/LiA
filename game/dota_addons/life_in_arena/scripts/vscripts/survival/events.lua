function Survival:OnPlayerPickHero(keys)
    PrintTable("OnPlayerPickHero",keys)
    local player = EntIndexToHScript(keys.player)
    local playerID = player:GetPlayerID()
    local hero = EntIndexToHScript(keys.heroindex)

    hero.creeps = 0
    hero.bosses = 0
    hero.deaths = 0
    hero.rating = 0
    hero.lumber = 3
    --FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = hero.lumber })
    
    table.insert(self.tHeroes, hero)
    
    self.nHeroCount = self.nHeroCount + 1
    
    player:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(playerID, DOTA_TEAM_GOODGUYS,true)
    hero:SetTeam(DOTA_TEAM_GOODGUYS)
    
    if PlayerResource:HasRandomed(playerID) then
        print(PlayerResource:GetPlayerName(playerID),"randomed hero")
        hero:SetGold(hero:GetGold()+50, false)
    end 
    hero:AddNewModifier(hero, nil, "modifier_stats_bonus_fix", nil)

end

---------------------------------------------------------------------------------------------------------------------------

function Survival:_OnHeroDeath(keys)
    PrintTable("OnHeroDeath",keys)
    local hero = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local attackerHero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID())
    
    local ownerHero = hero:GetPlayerOwner()
    if ownerHero then
        Timers:CreateTimer(0.1,function() ownerHero:SetKillCamUnit(nil) end) 
    end
    
    if (self.State == SURVIVAL_STATE_DUEL_TIME) and (hero == self.DuelFirstHero or hero == self.DuelSecondHero) then
        Survival:EndDuel(attackerHero,hero)
    else
        hero.deaths = hero.deaths + 1
        self.nDeathHeroes = self.nDeathHeroes + 1
        if self.nDeathHeroes == self.nHeroCount then
            GameRules:SetCustomVictoryMessage("#lose_message")
            GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
            --GameRules:ResetToHeroSelection()
        end
    end
end

function Survival:_OnCreepDeath()   
    self.nDeathCreeps = self.nDeathCreeps + 1
    if hero then
        hero.creeps = hero.creeps + 1
    end
end

function Survival:_OnBossDeath()  
    self.nDeathCreeps = self.nDeathCreeps + 1
    if hero then
        hero.bosses = hero.bosses + 1
        hero.lumber = hero.lumber + 3
        --FireGameEvent('cgm_player_lumber_changed', { player_ID = attacker:GetPlayerOwnerID(), lumber = hero.lumber })
        if attacker:GetPlayerOwner() then
            PopupNumbers(attacker:GetPlayerOwner() ,killed, "gold", Vector(0,180,0), 3, 3, POPUP_SYMBOL_PRE_PLUS, nil)
        end
    end
end

function Survival:OnEntityKilled(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local hero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID()) --находим героя игрока, владеющего юнитом
    
    if killed:IsRealHero() then
        Survival:_OnHeroDeath(keys)
        return
    elseif self.State == SURVIVAL_STATE_ROUND_FINALBOSS then
        Survival:_OnFinalBossDeath(keys)
        return
    elseif killed:GetUnitName() == tostring(self.nRoundNum).."_wave_creep"  then 
        Survival:_OnCreepDeath()   
    elseif killed:GetUnitName() == tostring(self.nRoundNum).."_wave_boss" then
        Survival:_OnBossDeath()
    end 
        
    if self.nDeathCreeps == self.nWaveMaxCount[self.nHeroCountCreepsSpawned] or killed:GetUnitName() == tostring(self.nRoundNum).."_wave_megaboss" then
        Survival:EndRound()
    end
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --self.nRoundNum = 19
        Survival:PrepareNextRound()
    end
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnConnectFull(event)
    for playerID = 0,DOTA_MAX_PLAYERS-1 do
        if PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)
            
            if hero then
                if hero.hidden then
                    Survival:UnhideHero(hero) --in utils.lua
                end
            end
        end
    end
end

function Survival:OnDisconnect(event)
    for playerID = 0,DOTA_MAX_PLAYERS-1 do
        if PlayerResource:GetConnectionState(playerID) ~= DOTA_CONNECTION_STATE_CONNECTED then
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)
            
            if hero then
                if hero.hidden then
                    Survival:HideHero(hero) --in utils.lua
                end
            end
        end
    end
end