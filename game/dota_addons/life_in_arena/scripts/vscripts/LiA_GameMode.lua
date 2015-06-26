
WAVE_SPAWN_COORD_LEFT    = Vector(-5550,  1900, 0)
WAVE_SPAWN_COORD_TOP     = Vector(-3450,  3800, 0)
ARENA_TELEPORT_COORD_TOP = Vector(-5024, -1360, 0)
ARENA_TELEPORT_COORD_BOT = Vector(-5024, -2360, 0)
ARENA_CENTER_COORD       = Vector(-5024, -1860, 0)

WAVE_NUM         = 1    --номер волны
WAVE_SPAWN_COUNT = {20,26,32,38,44,50,56,62,68,74}   --крипов на спавн
WAVE_MAX_COUNT   = {42,54,66,78,90,102,114,126,138,150}   --количество крипов и боссов с обоих спавнов

GOLD_PER_WAVE = {0,12,12,12,12,12,15,15,18,18,18,18,21,24,24,27,27,30,30,30}

PRE_WAVE_TIME = 60 --время между волнами
PRE_DUEL_TIME = 30 --время перед дуэлью

MAX_LEVEL     = 50

tPlayers = {}
tHeroes = {}

nPlayers = 0
nHeroCount    = 0
nDeathHeroes  = 0    -- мертвых героев
nDeathCreeps  = 0    --         крипов
FinalBossStageDeath1 = 0
FinalBossStageDeath2 = 0

IsDuelOccured = false
IsDuel        = false
IsPreWaveTime = false

uFinalBoss    = nil

--------------------------------------------------------------------------------

if LiA == nil then
	_G.LiA = class({})
	LiA.DeltaTime = 0.5
end


XP_TABLE = {}
XP_TABLE[1] = 0
for i = 2, MAX_LEVEL do
    XP_TABLE[i] = XP_TABLE[i-1] + i * 100 
end


function LiA:InitGameMode()

    self.vUserIds = {}

	GameRules:SetSafeToLeave(true)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetPreGameTime(0)
    GameRules:SetPostGameTime(30)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetGoldTickTime(2)
	GameRules:SetGoldPerTick(1)
	GameRules:SetTreeRegrowTime(60)
    GameRules:SetHeroMinimapIconScale(0.8)
    GameRules:SetCreepMinimapIconScale(0.8)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetHideKillMessageHeaders(true)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetCustomVictoryMessage("#victory_message")
    GameRules:SetCustomGameEndDelay(1)
    
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetFogOfWarDisabled(true)
    GameMode:SetCustomHeroMaxLevel(MAX_LEVEL)    
    GameMode:SetCustomXPRequiredToReachNextLevel(XP_TABLE)
    GameMode:SetUseCustomHeroLevels(true)
    GameMode:SetRecommendedItemsDisabled(true)
    GameMode:SetHUDVisible(12, false)
    GameMode:SetHUDVisible(1, false) 
    GameMode:SetTopBarTeamValuesVisible(false)
    GameMode:SetBuybackEnabled(false)
    GameMode:SetThink("onThink", self)
    GameMode:SetTowerBackdoorProtectionEnabled(false)
    GameMode:SetStashPurchasingDisabled(true)
    GameMode:SetLoseGoldOnDeath(false)
    GameMode:SetModifyExperienceFilter( Dynamic_Wrap( LiA, "ExperienceFilter" ), self )

    
    GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(0)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 8 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )


    Convars:RegisterCommand( "lia_force_round", onPlayerReadyToWave, "For force round", 0 )
      
    --listeners
    ListenToGameEvent('entity_killed', Dynamic_Wrap(LiA, 'OnEntityKilled'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(LiA, 'OnGameStateChange'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(LiA, 'OnPlayerPickHero'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(LiA, 'OnDisconnect'), self)
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(LiA, 'OnConnectFull'), self)
    
    TRIGGER_SHOP = Entities:FindByClassname(nil, "trigger_shop") --находим триггер отвечающий за работу магазина
    
    LinkLuaModifier( "modifier_stun_lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier( "modifier_hide_lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier( "modifier_orn_lua", LUA_MODIFIER_MOTION_NONE )
    --LinkLuaModifier( "modifier_damage_return_lua", "items/modifier_damage_return_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier( "modifier_test_lia", LUA_MODIFIER_MOTION_NONE )

   
    --InitLogFile("log/LiA.txt","Init LiA")
end

function LiA:ExperienceFilter(filterTable)
    if IsDuel then
        return false
    end
    return true
end

function LiA:OnConnectFull(event)
    PrintTable("OnConnectFull",event)
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID =player:GetPlayerID()

    self.vUserIds[event.userid] = player
    
    player.IsDisconnect = false
    
    table.insert(tPlayers,player)
    nPlayers = nPlayers + 1  
end

function LiA:OnDisconnect(event)
    PrintTable("OnDisconnect",event)
    local player = self.vUserIds[event.userid]
    if player.readyToWave then
        print("readyToWave")
        player.readyToWave = false
        nPlayersReady = nPlayersReady - 1
    end
    for k,v in pairs(tPlayers) do 
        if player == v then
            table.remove(tPlayers,k)
        end
    end
    nPlayers = nPlayers - 1
    --if player:GetAssignedHero() then
    --    nHeroCount = nHeroCount - 1
    --end
    player.IsDisconnect = true
end



function LiA:onThink()
    for i = 1, #tHeroes do
        local hero = tHeroes[i]
        hero.rating = hero.creeps * 2 + hero.bosses * 20 + hero.deaths * -15 + hero:GetLevel() * 30
        --print(hero.rating,PlayerResource:GetPlayerName(hero:GetPlayerID()))       
    end 
    table.sort(tHeroes,function(a,b) return a.rating > b.rating end)
    return LiA.DeltaTime
end


function LiA:OnPlayerPickHero(keys)
    PrintTable("OnPlayerPickHero",keys)
    local player = EntIndexToHScript(keys.player)
    local playerID = player:GetPlayerID()
    local hero = EntIndexToHScript(keys.heroindex)

    hero.creeps = 0
    hero.bosses = 0
    hero.deaths = 0
    hero.rating = 0
    hero.lumber = 3
    FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = hero.lumber })
    
    table.insert(tHeroes, hero)
    
    nHeroCount = nHeroCount + 1
    
    player:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(playerID, DOTA_TEAM_GOODGUYS,true)
    hero:SetTeam(DOTA_TEAM_GOODGUYS)
    
    hero:SetGold(100, false)
    if PlayerResource:HasRandomed(playerID) then
        print(PlayerResource:GetPlayerName(playerID),"randomed hero")
        hero:ModifyGold(50, false, DOTA_ModifyGold_Unspecified)
    end 
    --hero:AddNewModifier(hero, nil, "modifier_test_lia", nil)
end

function LiA:OnGameStateChange()  

    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        StartWaves()
    end
end

function OnHeroDeath(keys)
    PrintTable("OnHeroDeath",keys)
    local hero = EntIndexToHScript(keys.entindex_killed)
    local ownerHero = hero:GetPlayerOwner()
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    if ownerHero then
        Timers:CreateTimer(0.1,function() ownerHero:SetKillCamUnit(nil) end) 
    end
    if IsDuel and (hero == HeroOnDuel1 or hero == HeroOnDuel2) then
        EndDuel(attacker,hero)
    else
        hero.deaths = hero.deaths + 1
        nDeathHeroes = nDeathHeroes + 1
        if nDeathHeroes == nHeroCount then
            GameRules:SetCustomVictoryMessage("#lose_message")
            GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
            --GameRules:ResetToHeroSelection()
        end
    end
end

function LiA:OnEntityKilled(keys)
    local ent = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local ownedHeroAtt = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID()) --находим героя игрока, владеющего юнитом
    if ent:IsRealHero() then
        OnHeroDeath(keys)
        return
    elseif ent:HasAttribute("FirstStage") then
        OnFirstStageDeath(keys)
        return
    elseif ent:HasAttribute("SecondStage") then
        OnSecondStageDeath(keys)   
        return
    end
    if ent:GetUnitName() == tostring(WAVE_NUM).."_wave_creep"  then    
        nDeathCreeps = nDeathCreeps + 1
        if ownedHeroAtt then
            ownedHeroAtt.creeps = ownedHeroAtt.creeps + 1
        end
    elseif ent:GetUnitName() == tostring(WAVE_NUM).."_wave_boss" then
        nDeathCreeps = nDeathCreeps + 1
        if ownedHeroAtt then
            ownedHeroAtt.bosses = ownedHeroAtt.bosses + 1
            ownedHeroAtt.lumber = ownedHeroAtt.lumber + 3
            FireGameEvent('cgm_player_lumber_changed', { player_ID = attacker:GetPlayerOwnerID(), lumber = ownedHeroAtt.lumber })
            if attacker:GetPlayerOwner() then
                PopupNumbers(attacker:GetPlayerOwner() ,ent, "gold", Vector(0,180,0), 3, 3, POPUP_SYMBOL_PRE_PLUS, nil)
            end
        end
    end
    if nDeathCreeps == WAVE_MAX_COUNT[nHeroCount] or ent:GetUnitName() == tostring(WAVE_NUM).."_wave_megaboss" then
        print("Wave",WAVE_NUM,"finished")
        LiA._EndWave()
    end
end

function StartWaves()
    IsPreWaveTime = true
    timerPopup:Start(PRE_WAVE_TIME,"#lia_wave_num",WAVE_NUM)
    Timers:CreateTimer("preWaveMessageTimer",{ endTime = PRE_WAVE_TIME-3, callback = function() ShowCenterMessage("#lia_wave_num",5,WAVE_NUM) IsPreWaveTime = false return nil end})
    Timers:CreateTimer("preWaveTimer",{ endTime = PRE_WAVE_TIME, callback = function() LiA.SpawnWave() return nil end}) 
end


function LiA:SpawnWave()  
    print("Spawn wave", WAVE_NUM, "for", nPlayers, "players")
    IsPreWaveTime = false
    CreateUnitByName(tostring(WAVE_NUM).."_wave_boss", WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    CreateUnitByName(tostring(WAVE_NUM).."_wave_boss", WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    local creepName = tostring(WAVE_NUM).."_wave_creep"
    for i = 1, WAVE_SPAWN_COUNT[nHeroCount] do
        CreateUnitByName(creepName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName(creepName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    end
    TRIGGER_SHOP:Disable()  
end

function LiA:SpawnMegaboss()
    print("Spawn megaboss",WAVE_NUM)
    IsPreWaveTime = false
    CleanUnitsOnMap()
    local boss
    if WAVE_NUM == 20 then
        boss = CreateUnitByName("orn", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)
        boss:AddNewModifier(boss, nil, "modifier_orn_lua", {duration = -1})
        uFinalBoss = boss
    else
        boss = CreateUnitByName(tostring(WAVE_NUM).."_wave_megaboss", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)   
    end
    boss:SetForwardVector(Vector(0,-1,0))
    boss:AddNewModifier(boss, nil, "modifier_stun_lua", {duration = 5})
    LiA.TeleportToArena()
    TRIGGER_SHOP:Disable() 
    BossCounter = 5
    Timers:CreateTimer(function()
        if BossCounter == 0 then
            return nil
        else
            ShowCenterMessage(tostring(BossCounter),1)
            BossCounter = BossCounter - 1
            return 1
        end
    end)
end

function OnFirstStageDeath(event) --когда умирают боссы первой стадии финального босса
    FinalBossStageDeath1 = FinalBossStageDeath1 + 1
    if FinalBossStageDeath1 == 15 then
        uFinalBoss:RemoveModifierByName("modifier_hide_lua") 
        FindClearSpaceForUnit(uFinalBoss, ARENA_CENTER_COORD + RandomVector(RandomInt(-600, 600)), false)
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, uFinalBoss)
        uFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")
                
    end
end

function OnSecondStageDeath(event) 
    FinalBossStageDeath2 = FinalBossStageDeath2 + 1
    print("FinalBossStageDeath2",FinalBossStageDeath2)
    if FinalBossStageDeath2 == 10 then
        print("Second Stage Ended")
        uFinalBoss:RemoveModifierByName("modifier_hide_lua") 
        FindClearSpaceForUnit(uFinalBoss, ARENA_CENTER_COORD + RandomVector(RandomInt(-600, 600)), false)
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, uFinalBoss)
        uFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")
                
    end
end

function LiA:OnOrnDeath(event)
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) 
end

function LiA:OnOrnDamaged(event) 
    if event.unit:GetHealthPercent() <= 30 and not FinalBossStage2 and FinalBossStage1 then --зомби
        FinalBossStage2 = true
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, uFinalBoss)
        uFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")
        uFinalBoss:AddNewModifier(uFinalBoss, nil, "modifier_hide_lua", {duration = -1})
        uFinalBoss:SetAbsOrigin(Vector(0,0,0)) 
        FinalBossStageCounter = 1 
        FinalBossStageDeath2 = 0
        Timers:CreateTimer(2,function()
            if FinalBossStageCounter <= 10 then
                local unit = CreateUnitByName("orn_mutant", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, unit)
                unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
                unit:Attribute_SetIntValue("SecondStage",1)
                FinalBossStageCounter = FinalBossStageCounter + 1
                return 2
            else
                return nil
            end
        end)
    elseif event.unit:GetHealthPercent() <= 70 and not FinalBossStage1 then --на арену выходят все предыдущие боссы
        FinalBossStage1 = true
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, uFinalBoss)
        uFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")
        uFinalBoss:AddNewModifier(uFinalBoss, nil, "modifier_hide_lua", {duration = -1})
        uFinalBoss:SetAbsOrigin(Vector(0,0,0)) 
        FinalBossStageCounter = 5 
        FinalBossStageDeath1 = 0
        Timers:CreateTimer(2,function()
            if FinalBossStageCounter <= 19 then
                local unit
                if FinalBossStageCounter % 5 == 0 then
                    unit = CreateUnitByName(tostring(FinalBossStageCounter).."_wave_megaboss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                else
                    unit = CreateUnitByName(tostring(FinalBossStageCounter).."_wave_boss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                end
                print("Spawned Boss",FinalBossStageCounter,unit:GetUnitName())    
                unit:Attribute_SetIntValue("FirstStage",1)
                ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, unit)
                unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
                FinalBossStageCounter = FinalBossStageCounter + 1
                return 2
            else
                return nil
            end
        end)
    end
end

function LiA:_EndWave()
    print("EndWave")
    nPlayersReady = 0
    for _,player in pairs(tPlayers) do
        player.readyToWave = false
    end
    WAVE_NUM = WAVE_NUM + 1
    nDeathCreeps = 0
    nDeathHeroes = 0
    if WAVE_NUM % 5 == 1 then  --телепорт героев с арены после мегабосса
        LiA.TeleportWithoutArena()
    end
    if WAVE_NUM % 3 == 1 and not IsDuelOccured and nHeroCount > 1 then --проверка могут ли начаться дуэли
        print("EndWave:Duels started")
        StartDuels()
    else
        IsPreWaveTime = true
        IsDuelOccured = false
        print("EndWave: next wave",WAVE_NUM)

        local message
        if WAVE_NUM % 5 == 0 then --мегабосс
            Timers:CreateTimer("preWaveTimer",{ endTime = PRE_WAVE_TIME, callback = function() LiA.SpawnMegaboss() return nil end})
            if WAVE_NUM == 20 then
                message = "#lia_finalboss"
            else
                message = "#lia_megaboss"
            end
            timerPopup:Start(PRE_WAVE_TIME,message,0)
            Timers:CreateTimer("preWaveMessageTimer",{ endTime = PRE_WAVE_TIME-3, callback = function() ShowCenterMessage(message,5) IsPreWaveTime = false return nil end})
        else --обычные волны
            Timers:CreateTimer("preWaveTimer",{ endTime = PRE_WAVE_TIME, callback = function() LiA.SpawnWave() return nil end})
            message = "#lia_wave_num"
            timerPopup:Start(PRE_WAVE_TIME,"#lia_wave_num",WAVE_NUM)
            Timers:CreateTimer("preWaveMessageTimer",{ endTime = PRE_WAVE_TIME-3, callback = function() ShowCenterMessage(message,5,WAVE_NUM) IsPreWaveTime = false return nil end})
        end
         
        GoldAdd = WAVE_SPAWN_COUNT[nPlayers] / nPlayers * GOLD_PER_WAVE[WAVE_NUM]
        DoWithAllHeroes(function(hero)
            hero:ModifyGold(GoldAdd, false, DOTA_ModifyGold_Unspecified)
            hero.lumber = hero.lumber + 3 + WAVE_NUM
            FireGameEvent('cgm_player_lumber_changed', { player_ID = hero:GetPlayerID(), lumber = hero.lumber })
        end)        
    end
    TRIGGER_SHOP:Enable()
    Timers:CreateTimer(0.5,function() 
        RespawnAllHeroes()
    end)
    DoWithAllHeroes(function(hero)
        if hero:IsAlive() then
            hero:Heal(9999,hero)
            hero:GiveMana(9999)
        end
    end)

    --убиваем всех оставшихся после волны юнитов
    CleanUnitsOnMap()

    PrecacheUnitByNameAsync(tostring(WAVE_NUM).."_wave_creep", function(...) end)
    PrecacheUnitByNameAsync(tostring(WAVE_NUM).."_wave_boss", function(...) end)
end

function LiA:TeleportToArena() --Телепорт на арену
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

function LiA:TeleportWithoutArena() --Телепорт с арены
    DoWithAllHeroes(function(hero)
        hero:Stop()
        FindClearSpaceForUnit(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerID(),hero.abs)
    end)
end

function GetHeroToDuel()
    for i = 1, #tHeroes do
        if not tHeroes[i].IsDueled and IsValidEntity(tHeroes[i]) then
            tHeroes[i].IsDueled = true
            return tHeroes[i]
        end
    end
    return nil 
end

function StartDuels()
    DuelNumber = 1
    CleanUnitsOnMap()
    timerPopup:Start(PRE_DUEL_TIME,"#lia_duel",0)
    Timers:CreateTimer(PRE_DUEL_TIME,function()
        IsDuel = true
        TRIGGER_SHOP:Disable() 
        DoWithAllHeroes(function(hero)
            hero:AddNewModifier(hero, nil, "modifier_stun_lua", {duration = -1})
        end)
        local firstHero = GetHeroToDuel()
        local secondHero = GetHeroToDuel()
        if firstHero and secondHero then
            Duel(firstHero,secondHero)
            print("firstHero",firstHero:GetUnitName())
            print("secondHero",secondHero:GetUnitName())
            SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD) 
        else
            EndDuels()
        end

    end)
end

function EndDuels()
    print(DuelNumber,"end duels")
    IsDuel = false
    IsDuelOccured = true
    for i = 1, #tHeroes do
        tHeroes[i].IsDueled = false
    end
    WAVE_NUM = WAVE_NUM - 1
    DoWithAllHeroes(function(hero)
        if hero:IsAlive() then
            hero:RemoveModifierByName("modifier_stun_lua")
            SetCameraToPosForPlayer(hero:GetPlayerID(),hero:GetAbsOrigin())
        else
            --Timers:CreateTimer(0.5,function() 
            --    hero:RespawnHero(false, false, false)
            --end)
        end
    end)
    LiA:_EndWave()
end


function Duel(hero1, hero2)
    HeroOnDuel1 = hero1 
    HeroOnDuel2 = hero2 
    HeroOnDuel1.abs = HeroOnDuel1:GetAbsOrigin()
    HeroOnDuel2.abs = HeroOnDuel2:GetAbsOrigin()
    HeroOnDuel1:Stop()
    HeroOnDuel2:Stop()
    HeroOnDuel1:SetForwardVector(Vector(0,1,0))
    HeroOnDuel2:SetForwardVector(Vector(0,-1,0))
    FindClearSpaceForUnit(HeroOnDuel1, ARENA_TELEPORT_COORD_BOT, false) 
    FindClearSpaceForUnit(HeroOnDuel2, ARENA_TELEPORT_COORD_TOP, false)

    if hero2:GetPlayerOwner() then 
       hero2:GetPlayerOwner():SetTeam(DOTA_TEAM_BADGUYS)
    end
    HeroOnDuel2:SetTeam(DOTA_TEAM_BADGUYS)
    PlayerResource:UpdateTeamSlot(HeroOnDuel2:GetPlayerID(), DOTA_TEAM_BADGUYS,true)

    HeroOnDuel1:Heal(9999,HeroOnDuel1)
    HeroOnDuel2:Heal(9999,HeroOnDuel2)
    HeroOnDuel1:GiveMana(9999)
    HeroOnDuel2:GiveMana(9999)
    ResetAllAbilitiesCooldown(HeroOnDuel1)
    ResetAllAbilitiesCooldown(HeroOnDuel2)

    SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD)

    DuelCounter = 5
    Timers:CreateTimer(function()
        if DuelCounter == 0 then
            HeroOnDuel1:RemoveModifierByName("modifier_stun_lua")
            HeroOnDuel2:RemoveModifierByName("modifier_stun_lua")
            timerPopup:Start(120,"#lia_expire_duel",0)
            Timers:CreateTimer("duelExpireTime",{ --таймер дуэли
                useGameTime = true,
                endTime = 120,
                callback = function()
                    EndDuel(nil,nil)
                    return nil
                end})
            return nil
        else
            ShowCenterMessage(tostring(DuelCounter),1)
            DuelCounter = DuelCounter - 1
            return 1
        end
    end)
end


function EndDuel(winner,loser)
    CleanUnitsOnMap()
    winner = PlayerResource:GetSelectedHeroEntity(winner:GetPlayerOwnerID()) --находим героя, владеющего юнитом-убийцей(если убил не сам герой, а его саммон)
    if winner and loser then --проверка на отсутствие ничьей
        if winner == loser then -- проверяем самоубился ли герой
            if loser == HeroOnDuel2 then -- устанавливаем другого героя победителем
                winner = HeroOnDuel1
            else
                winner = HeroOnDuel2
            end
        end
        print("Winner",winner:GetUnitName())
        print("Loser",loser:GetUnitName())
    end

    if winner ~= nil then 
        timerPopup:Stop()
        Timers:RemoveTimer("duelExpireTime")
        
        winner:ModifyGold(300-50*DuelNumber, false, DOTA_ModifyGold_Unspecified)
        winner.lumber = winner.lumber + 9 - DuelNumber
        FireGameEvent('cgm_player_lumber_changed', { player_ID = winner:GetPlayerID(), lumber = winner.lumber })
        
        if winner:IsAlive() then
            winner:Stop()
            FindClearSpaceForUnit(winner, winner.abs, false)
        end
    else --ничья
        FindClearSpaceForUnit(HeroOnDuel1, HeroOnDuel1.abs, false) 
        FindClearSpaceForUnit(HeroOnDuel2, HeroOnDuel2.abs, false) 
        --GameRules:SendCustomMessage("#lia_duel_expiretime", DOTA_TEAM_GOODGUYS, 0)
    end
    if HeroOnDuel2:GetPlayerOwner() then
        HeroOnDuel2:GetPlayerOwner():SetTeam(DOTA_TEAM_GOODGUYS)
    end
    HeroOnDuel2:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(HeroOnDuel2:GetPlayerID(), DOTA_TEAM_GOODGUYS,true) 

    if HeroOnDuel1:IsAlive() then
        HeroOnDuel1:Purge(false, true, false, true, false)
        HeroOnDuel1:AddNewModifier(HeroOnDuel1, nil, "modifier_stun_lua", {duration = -1})
        HeroOnDuel1:Heal(9999,HeroOnDuel1)
        HeroOnDuel1:GiveMana(9999)    
    end

    if HeroOnDuel2:IsAlive() then
        HeroOnDuel2:Purge(false, true, false, true, false)
        HeroOnDuel2:AddNewModifier(HeroOnDuel2, nil, "modifier_stun_lua", {duration = -1})
        HeroOnDuel2:Heal(9999,HeroOnDuel2)
        HeroOnDuel2:GiveMana(9999) 
    end

    HeroOnDuel1 = nil
    HeroOnDuel2 = nil

    if DuelNumber < math.floor(nPlayers / 2) then
        DuelNumber = DuelNumber + 1
        local firstHero = GetHeroToDuel()
        local secondHero = GetHeroToDuel()
        if firstHero and secondHero then
            print("Next duel", DuelNumber)
            print("firstHero",firstHero:GetUnitName())
            print("secondHero",secondHero:GetUnitName())
            Duel(firstHero,secondHero)
        else
            EndDuels()
        end

    else
        EndDuels()
    end
end

