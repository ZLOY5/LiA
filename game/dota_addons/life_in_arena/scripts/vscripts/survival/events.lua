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
	hero.percUlu = 0
	hero.lumberSpent = 0
    --FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = hero.lumber })
    
    table.insert(self.tHeroes, hero)
    
    self.nHeroCount = self.nHeroCount + 1
    
    player:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(playerID, DOTA_TEAM_GOODGUYS)
    hero:SetTeam(DOTA_TEAM_GOODGUYS)
    
    if PlayerResource:HasRandomed(playerID) then
        print(PlayerResource:GetPlayerName(playerID),"randomed hero")
        hero:SetGold(hero:GetGold()-150, false) -- в доте за рандом дают 200 золота
    end 
    --hero:AddNewModifier(hero, nil, "modifier_stats_bonus_fix", nil)

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
            Survival:EndGame(DOTA_TEAM_BADGUYS)
            --GameRules:ResetToHeroSelection()
        end
    end
end

function Survival:_OnCreepDeath(keys)   
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local hero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID()) --находим героя игрока, владеющего юнитом
    
    if hero then
        hero.creeps = hero.creeps + 1
    end

    self.nDeathCreeps = self.nDeathCreeps + 1
    if self.nDeathCreeps == self.nWaveMaxCount[self.nHeroCountCreepsSpawned] then
        Survival:EndRound()
    end
end

function Survival:_OnBossDeath(keys)  
    local killed = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local hero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID()) --находим героя игрока, владеющего юнитом
    
    if hero then
        hero.bosses = hero.bosses + 1
        hero.lumber = hero.lumber + 3
        --FireGameEvent('cgm_player_lumber_changed', { player_ID = attacker:GetPlayerOwnerID(), lumber = hero.lumber })
        if attacker:GetPlayerOwner() then
            PopupNumbers(attacker:GetPlayerOwner() ,killed, "gold", Vector(0,180,0), 3, 3, POPUP_SYMBOL_PRE_PLUS, nil)
        end
    end

    self.nDeathCreeps = self.nDeathCreeps + 1
    if self.nDeathCreeps == self.nWaveMaxCount[self.nHeroCountCreepsSpawned] then
        Survival:EndRound()
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
    elseif killed:GetUnitName() == tostring(self.nRoundNum).."_wave_creep" and not killed:IsOwnedByAnyPlayer() then 
        Survival:_OnCreepDeath(keys)   
    elseif killed:GetUnitName() == tostring(self.nRoundNum).."_wave_boss" and not killed:IsOwnedByAnyPlayer() then
        Survival:_OnBossDeath(keys)
    elseif killed:GetUnitName() == tostring(self.nRoundNum).."_wave_megaboss" then
        Survival:EndRound()
    end 

    Survival:AICreepsRemoveFromTable(killed)
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --self.nRoundNum = 10
        Survival:PrepareNextRound()
    end
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnConnectFull(event)
    --[[Timers:CreateTimer(0.5,function()
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
    end)]]
end

function Survival:OnDisconnect(event)
    --[[Timers:CreateTimer(0.5,function()
        for playerID = 0,DOTA_MAX_PLAYERS-1 do
            if PlayerResource:GetConnectionState(playerID) ~= DOTA_CONNECTION_STATE_CONNECTED then
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                
                if hero then
                    if not hero.hidden then
                        Survival:HideHero(hero) --in utils.lua
                    end
                end
            end
        end
    end)]]
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnPlayerChat(event)
    --PrintTable("Survival:OnPlayerChat",event)
    local player = LiA.vUserIds[event.userid]

    if event.text == "+" then
        onPlayerReadyToWave(player) --LiA_ForceRound.lua
    end
	
    --[[if event.text == "lumber" then
		player:GetAssignedHero().lumber = 1000
        --onPlayerReadyToWave(player) --LiA_ForceRound.lua
    end
	]]
	
	
	
end