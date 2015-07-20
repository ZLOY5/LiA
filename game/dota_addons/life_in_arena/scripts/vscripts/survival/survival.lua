
_G.SURVIVAL_STATE_PRE_GAME = 0
_G.SURVIVAL_STATE_PRE_ROUND_TIME = 1
_G.SURVIVAL_STATE_ROUND_WAVE = 2
_G.SURVIVAL_STATE_ROUND_MEGABOSS = 3
_G.SURVIVAL_STATE_ROUND_FINALBOSS = 4
_G.SURVIVAL_STATE_PRE_DUEL_TIME = 5
_G.SURVIVAL_STATE_DUEL_TIME = 6
_G.SURVIVAL_STATE_POST_GAME = 7

_G.WAVE_SPAWN_COORD_LEFT    = Vector(-5700,  1850, 0)
_G.WAVE_SPAWN_COORD_TOP     = Vector(-3670,  3970, 0) 
_G.ARENA_TELEPORT_COORD_TOP = Vector(-5024, -1360, 0)
_G.ARENA_TELEPORT_COORD_BOT = Vector(-5024, -2360, 0)
_G.ARENA_CENTER_COORD       = Vector(-5024, -1860, 0)

------------------------------------------------------------------------------------------------

if Survival == nil then
    print("Survival")
    
	_G.Survival = class({})
end

------------------------------------------------------------------------------------------------

require('survival/duels')

------------------------------------------------------------------------------------------------


function Survival:InitSurvival()
    Survival = self

    self.tHeroes = {}
	self.nRoundNum = 0

    self.nHeroCount = 0
	self.nDeathHeroes = 0
	self.nDeathCreeps = 0
	self.nWaveSpawnCount = {20,26,32,38,44,50,56,62,68,74}   --крипов на спавн
	self.nWaveMaxCount = {42,54,66,78,90,102,114,126,138,150}

	self.nGoldPerWave = {0,12,12,12,12,12,15,15,18,18,18,18,21,24,24,27,27,30,30,30}

    self.flExpFix = {0.8, 0.9, 1., 1.1, 1.2, 1.3, 1.4, 1.5}
    
    self.flExtremeExpMultiplier = -0.3
    self.flLightExpMultiplier = 0.2

    self.IsAllRandom = false
    self.IsExtreme = false
    self.IsLight = false

	self.nPreRoundTime = 60
	self.nPreDuelTime = 30
    self.nDuelTime = 120

    self.State = SURVIVAL_STATE_PRE_GAME

    self.IsDuelOccured = false

	GameRules:SetCustomVictoryMessage("#victory_message")
    GameRules:SetHideKillMessageHeaders(true)
    GameRules:SetTreeRegrowTime(60)
    GameRules:SetHeroRespawnEnabled(false)

    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetThink("onThink", self)
    GameMode:SetFogOfWarDisabled(true)

    GameMode:SetModifyExperienceFilter(Dynamic_Wrap(Survival, "ExperienceFilter"), self)

    ListenToGameEvent('entity_killed', Dynamic_Wrap(Survival, 'OnEntityKilled'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Survival, 'OnPlayerPickHero'), self)
    
end

function Survival:ExperienceFilter(filterTable)
    --PrintTable("ExperienceFilter",filterTable)
    if Survival.State == SURVIVAL_STATE_DUEL_TIME then --на дуэлях опыта не даем
        return false
    end

    local expMultiplier = self.flExpFix[self.nHeroCount] -- коррекция получаемого опыта зависимо от кол-ва героев в игре
    
    if self.IsExtreme then --множитель опыта для экстрима и лайта
        expMultiplier = expMultiplier + self.flExtremeExpMultiplier
    elseif self.IsLight then
        expMultiplier = expMultiplier + self.flLightExpMultiplier
    end

    filterTable.experience = filterTable.experience * expMultiplier
    return true

end

function Survival:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        Survival:PrepareNextRound()
    end
end

function Survival:onThink()
    for i = 1, #self.tHeroes do
        local hero = self.tHeroes[i]
        hero.rating = hero.creeps * 2 + hero.bosses * 20 + hero.deaths * -15 + hero:GetLevel() * 30
    end 
    table.sort(self.tHeroes,function(a,b) return a.rating > b.rating end)
    return 0.25
end

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
    
    hero:SetGold(100, false)
    if PlayerResource:HasRandomed(playerID) then
        print(PlayerResource:GetPlayerName(playerID),"randomed hero")
        hero:SetGold(hero:GetGold()+50, false)
    end 
    --hero:AddNewModifier(hero, nil, "modifier_test_lia", nil)

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

function Survival:_TeleportHeroesWithoutBossArena()
    DoWithAllHeroes(function(hero)
        hero:Stop()
        FindClearSpaceForUnit(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerID(),hero.abs)
    end)
end

function Survival:EndRound()
    self.nDeathCreeps = 0
    self.nDeathHeroes = 0
    
    CleanUnitsOnMap()

    nPlayersReady = 0
    for _,player in pairs(LiA.tPlayers) do
        player.readyToWave = false
    end
    
    local GoldAdd = self.nWaveSpawnCount[self.nHeroCount] / self.nHeroCount * self.nGoldPerWave[self.nRoundNum]
    DoWithAllHeroes(function(hero)
        if hero:IsAlive() then
            hero:Purge(false, true, false, true, false)
            hero:Heal(9999,hero)
            hero:GiveMana(9999)
        end
        hero:SetGold(hero:GetGold()+GoldAdd, false)
        hero.lumber = hero.lumber + 3 + self.nRoundNum
        --FireGameEvent('cgm_player_lumber_changed', { player_ID = hero:GetPlayerID(), lumber = hero.lumber })
    end)
    Timers:CreateTimer(0.5,function() 
        RespawnAllHeroes()
    end)  

    Timers:CreateTimer(1,function()
        if Survival.State == SURVIVAL_STATE_ROUND_MEGABOSS then
            Survival:_TeleportHeroesWithoutBossArena()
        end
        EnableShop()
        Survival:PrepareNextRound()
        end
    )
end

function Survival:_TimerMessage()
    if self.nRoundNum % 5 == 0 then
        local message
        if self.nRoundNum == 20 then
            message = "#lia_finalboss"
        else
            message = "#lia_megaboss"
        end
        timerPopup:Start(self.nPreRoundTime,message,0)
    else
        timerPopup:Start(self.nPreRoundTime,"#lia_wave_num",self.nRoundNum)
    end
end

function Survival:PrepareNextRound()
    self.nRoundNum = self.nRoundNum + 1
    
    if self.nRoundNum % 3 == 1 and not self.IsDuelOccured and self.nHeroCount > 1 then
        print("Next round - duels")
        self.IsDuelOccured = true
        Survival.State = SURVIVAL_STATE_PRE_DUEL_TIME
        Survival:StartDuels()
    else
        print("Next round - ", self.nRoundNum)
        self.IsDuelOccured = false
        Survival.State = SURVIVAL_STATE_PRE_ROUND_TIME

        Survival:_TimerMessage()

        Timers:CreateTimer("StartRoundTimer",
            {
                endTime = self.nPreRoundTime-3, 
                callback = function() Survival:StartRound() end
            }
        )

        PrecacheUnitByNameAsync(tostring(self.nRoundNum).."_wave_creep", function(...) end)
        PrecacheUnitByNameAsync(tostring(self.nRoundNum).."_wave_boss", function(...) end)
    end
end

--------------------------------------------------------------------------------------------------

function Survival:_TeleportHeroesToBossArena()
    DoWithAllHeroes(function(hero)
        hero.abs = hero:GetAbsOrigin() 
        hero:Stop()
        hero:SetForwardVector(Vector(0, 1, 0))
        FindClearSpaceForUnit(hero, ARENA_TELEPORT_COORD_BOT + Vector(RandomInt(-200,200),RandomInt(-50,50),0), false)

        hero:Heal(9999,hero)
        hero:GiveMana(9999)
        hero:AddNewModifier(hero, nil, "modifier_stun_lua", {duration = 5})
    end) 
    SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD) 
end

function Survival:_SpawnMegaboss()
    print("Spawn megaboss")
    local boss
    if self.nRoundNum == 20 then
        boss = CreateUnitByName("orn", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)
        boss:AddNewModifier(boss, nil, "modifier_orn_lua", {duration = -1})
        self.hFinalBoss = boss
    else
        boss = CreateUnitByName(tostring(self.nRoundNum).."_wave_megaboss", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)   
    end
    boss:SetForwardVector(Vector(0,-1,0))
    boss:AddNewModifier(boss, nil, "modifier_stun_lua", {duration = 5})
end

function Survival:_SpawnWave()  
    print("Spawn wave", self.nRoundNum, "for", self.nHeroCount, "heroes")
    
    self.nHeroCountCreepsSpawned = self.nHeroCount --чтобы уберечь от багов при изменении кол-ва героев во время волны(кто-то взял героя после старта волны например)
    
    local unit1, unit2, boss1, boss2
    local creepName = tostring(self.nRoundNum).."_wave_creep"
    local bossName = tostring(self.nRoundNum).."_wave_boss"
    local pathEffect = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
    
    boss1 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    boss2 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss1)
    ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss2)
    boss1:EmitSound("DOTA_Item.BlinkDagger.Activate")
    boss2:EmitSound("DOTA_Item.BlinkDagger.Activate")
     
    local spawnCount = 0
    
    local all_time = 2.0
    local tick = all_time/self.nWaveSpawnCount[self.nHeroCount]
    --
    Timers:CreateTimer(tick,
        function()
            unit1 = CreateUnitByName(creepName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            unit2 = CreateUnitByName(creepName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            --
            ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, unit1)
            ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, unit2)
            unit1:EmitSound("DOTA_Item.BlinkDagger.Activate")
            unit2:EmitSound("DOTA_Item.BlinkDagger.Activate")
            --particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf
            spawnCount = spawnCount + 1
            if spawnCount == self.nWaveSpawnCount[self.nHeroCountCreepsSpawned] then
                return nil
            else
                return tick
            end
        end
    ) 
end

function Survival:StartRound()
    if self.nHeroCount == 0 then 
        GameRules:SetCustomVictoryMessage("#lose_message")
        GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
        return   
    end
    
    if self.nRoundNum % 5 == 0 then
        Survival.State = SURVIVAL_STATE_ROUND_MEGABOSS 

        local message      
        if self.nRoundNum == 20 then
            message = "#lia_finalboss"
        else
            message = "#lia_megaboss"
        end
        ShowCenterMessage(message,5)
    else
        Survival.State = SURVIVAL_STATE_ROUND_WAVE        
        ShowCenterMessage("#lia_wave_num",5,self.nRoundNum)
    end

    Timers:CreateTimer(3,function()
            DisableShop()
            
            if self.nRoundNum % 5 == 0 then -- мегабоосс
                CleanUnitsOnMap()
                Survival:_TeleportHeroesToBossArena()
                Survival:_SpawnMegaboss()
                
                BossCounter = 5
                Timers:CreateTimer(
                    function()
                        if BossCounter == 0 then
                            return nil
                        else
                            ShowCenterMessage(tostring(BossCounter),1)
                            BossCounter = BossCounter - 1
                            return 1
                        end
                    end
                )
            else -- обычная волна
                Survival:_SpawnWave()
            end
        end
    ) 
end

--------------------------------------------------------------------------------------------------