
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

tPlayersTop  = {}
tHeroes = {}

nPlayers = 0
nHeroCount    = 0
nDeathHeroes  = 0    -- мертвых героев
nDeathCreeps  = 0    --         крипов
FinalBossStageDeath = 0

IsDuelOccured = false
IsDuel        = false
IsPreWaveTime = false

uFinalBoss    = nil

--------------------------------------------------------------------------------

if LiA == nil then
	LiA = class({})
	LiA.DeltaTime = 0.25
end


XP_TABLE = {}
XP_TABLE[1] = 0
for i = 2, MAX_LEVEL do
    XP_TABLE[i] = XP_TABLE[i-1] + i * 100 
end


function LiA:InitGameMode()
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
    LinkLuaModifier( "modifier_test_lia", LUA_MODIFIER_MOTION_NONE )
end

function LiA:OnConnectFull(event)
    for k,v in pairs(event) do
        print(k,v)
    end
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID =player:GetPlayerID()
    player.creeps = 0
    player.bosses = 0
    player.deaths = 0
    player.rating = 0
    player.lumber = 3
    FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = player.lumber })
    table.insert(tPlayersTop, player)
    nPlayers = nPlayers + 1
    
end

function LiA:OnDisconnect(event)
    print("OnDisconnect")
    for k,v in pairs(event) do
        print(k,v)
    end
    print(" ")
    local player = PlayerResource:GetPlayer(event.userid-1) 
    if player.readyToWave then
        nPlayersReady = nPlayersReady - 1
    end
    nPlayers = nPlayers - 1
    if player:GetAssignedHero() then
        nHeroCount = nHeroCount - 1
    end
    player.IsDisconnect = true
end


function LiA:onThink()
    for i = 1, #tPlayersTop do
        local player = tPlayersTop[i]
        local hero = player:GetAssignedHero()
        player.rating = player.creeps * 2 + player.bosses * 20 + player.deaths * -15
        if hero then
            player.rating = player.rating + hero:GetLevel() * 30
        end
        --print(player.rating,PlayerResource:GetPlayerName(player:GetPlayerID()))       
    end 
    table.sort(tPlayersTop,function(a,b) return a.rating < b.rating end)
    return LiA.DeltaTime
end


function LiA:OnPlayerPickHero(keys)
    print("OnPlayerPickHero")
    local player = PlayerResource:GetPlayer(keys.player-1) 
    local hero = EntIndexToHScript(keys.heroindex)
    table.insert(tHeroes, hero)
    nHeroCount = nHeroCount + 1
    player:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(player:GetPlayerID(), DOTA_TEAM_GOODGUYS,true)
    hero:SetTeam(DOTA_TEAM_GOODGUYS)
    if PlayerResource:HasRandomed(keys.player-1) then
        PlayerResource:SetGold(keys.player-1, 100, false) 
    else
        PlayerResource:SetGold(keys.player-1, 150, false) 
    end 
    --hero:AddNewModifier(hero, nil, "modifier_test_lia", nil)
end

function LiA:OnGameStateChange()  
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        StartWaves()
    end
end

function OnHeroDeath(keys)
    print("OnHeroDeath")
    local hero = EntIndexToHScript(keys.entindex_killed)
    local ownerHero = hero:GetPlayerOwner()
    local ownerAtt = EntIndexToHScript(keys.entindex_attacker):GetPlayerOwner()
    Timers:CreateTimer(0.1,function() ownerHero:SetKillCamUnit(nil) end) 
    if IsDuel then
        EndDuel(ownerAtt,ownerHero)
    else
        ownerHero.deaths = ownerHero.deaths + 1
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
    local ownerAtt = EntIndexToHScript(keys.entindex_attacker):GetPlayerOwner()
    if ent:IsRealHero() and not ent:HasModifier("modifier_shadow") then
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
        if ownerAtt ~= nil then
            ownerAtt.creeps = ownerAtt.creeps + 1
        end
    elseif ent:GetUnitName() == tostring(WAVE_NUM).."_wave_boss" then
        nDeathCreeps = nDeathCreeps + 1
        if ownerAtt ~= nil then
            ownerAtt.bosses = ownerAtt.bosses + 1
            ownerAtt.lumber = ownerAtt.lumber + 3
            FireGameEvent('cgm_player_lumber_changed', { player_ID = ownerAtt:GetPlayerID(), lumber = ownerAtt.lumber })
            PopupNumbers(ownerAtt ,ent, "gold", Vector(0,255,0), 3, 3, POPUP_SYMBOL_PRE_PLUS, nil)
        end
    end
    if nDeathCreeps == WAVE_MAX_COUNT[nHeroCount] or ent:GetUnitName() == tostring(WAVE_NUM).."_wave_megaboss" then
        Timers:CreateTimer(1,function() LiA._EndWave() return nil end)
    end
end

function StartWaves()
    IsPreWaveTime = true
    timerPopup:Start(PRE_WAVE_TIME,"#lia_wave_num",WAVE_NUM)
    Timers:CreateTimer("preWaveMessageTimer",{ endTime = PRE_WAVE_TIME-3, callback = function() ShowCenterMessage("#lia_wave_num",5,WAVE_NUM) IsPreWaveTime = false return nil end})
    Timers:CreateTimer("preWaveTimer",{ endTime = PRE_WAVE_TIME, callback = function() LiA.SpawnWave() return nil end}) 
end


function LiA:SpawnWave()  
    print(nPlayers,"players")
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
    IsPreWaveTime = false
    CleanUnitsOnMap()
    local boss
    if WAVE_NUM == 20 then
        boss = CreateUnitByName("orn", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)
        uFinalBoss = boss
        giveUnitDataDrivenModifier(boss, boss, "modifier_orn",-1)
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
    FinalBossStageDeath = FinalBossStageDeath + 1
    if FinalBossStageDeath == 15 then
        uFinalBoss:RemoveModifierByName("modifier_hide") 
        FindClearSpaceForUnit(uFinalBoss, ARENA_CENTER_COORD + RandomVector(RandomInt(-600, 600)), false)
    end
end

function OnSecondStageDeath(event) 
    FinalBossStageDeath = FinalBossStageDeath + 1
    print("FinalBossStageDeath",FinalBossStageDeath)
    if FinalBossStageDeath == 10 then
        print("Second Stage Ended")
        uFinalBoss:RemoveModifierByName("modifier_hide") 
        FindClearSpaceForUnit(uFinalBoss, ARENA_CENTER_COORD + RandomVector(RandomInt(-600, 600)), false)
    end
end

function OnOrnDeath(event)
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) 
end

function OnOrnDamaged(event) 
    if event.unit:GetHealthPercent() <= 30 and not FinalBossStage2 then --зомби
        FinalBossStage2 = true
        giveUnitDataDrivenModifier(uFinalBoss, uFinalBoss, "modifier_hide",-1)
        uFinalBoss:SetAbsOrigin(Vector(0,0,0)) 
        FinalBossStageCounter = 1 
        FinalBossStageDeath = 0
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
        giveUnitDataDrivenModifier(uFinalBoss, uFinalBoss, "modifier_hide",-1)
        uFinalBoss:SetAbsOrigin(Vector(0,0,0)) 
        FinalBossStageCounter = 5 
        FinalBossStageDeath = 0
        Timers:CreateTimer(2,function()
            if FinalBossStageCounter <= 19 then
                local unit
                if FinalBossStageCounter % 5 == 0 then
                    unit = CreateUnitByName(tostring(FinalBossStageCounter).."_wave_megaboss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                else
                    unit = CreateUnitByName(tostring(FinalBossStageCounter).."_wave_boss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                 end
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
    print("EndWave:started")
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
        print("EndWave:wave")
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
         
        IsDuelOccured = false
        GoldAdd = WAVE_SPAWN_COUNT[nPlayers] / nPlayers * GOLD_PER_WAVE[WAVE_NUM]
        DoWithAllHeroes(function(hero)
            local player = hero:GetPlayerOwner()
            hero:ModifyGold(GoldAdd, true, DOTA_ModifyGold_Unspecified)
            player.lumber = player.lumber + 3 + WAVE_NUM
            FireGameEvent('cgm_player_lumber_changed', { player_ID = hero:GetPlayerID(), lumber = player.lumber })
        end)        
    end
    TRIGGER_SHOP:Enable() 
    RespawnAllHeroes()
    DoWithAllHeroes(function(hero)
        hero:Heal(9999,hero)
        hero:GiveMana(9999)
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
        SetCameraToPosForAll(ARENA_CENTER_COORD) 
	end)  
end

function LiA:TeleportWithoutArena() --Телепорт с арены
    DoWithAllHeroes(function(hero)
        hero:Stop()
        FindClearSpaceForUnit(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerOwnerID(),hero.abs) 
    end)
end

function GetPlayerToDuel()
    for i = 1, #tPlayersTop do
        if not tPlayersTop[i].IsDisconnect and tPlayersTop[i]:GetAssignedHero() and not tPlayersTop[i].IsDueled then
            tPlayersTop[i].IsDueled = true
            return tPlayersTop[i]
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
        local firstPlayer = GetPlayerToDuel()
        local secondPlayer = GetPlayerToDuel()
        if firstPlayer and secondPlayer then
            Duel(firstPlayer,secondPlayer)
            SetCameraToPosForAll(ARENA_CENTER_COORD) 
        else
            EndDuels()
        end
        print("firstPlayer",firstPlayer)
        print("secondPlayer",secondPlayer)
    end)
end

function EndDuels()
    print(DuelNumber,"end duels")
    IsDuel = false
    IsDuelOccured = true
    for i = 1, #tPlayersTop do
        tPlayersTop[i].IsDueled = false
    end
    WAVE_NUM = WAVE_NUM - 1
    DoWithAllHeroes(function(hero)
        hero:RemoveModifierByName("modifier_stun_lua")
        SetCameraToPosForPlayer(hero:GetPlayerOwnerID(),hero:GetAbsOrigin())
    end)
    LiA:_EndWave()
end


function Duel(player1, player2)
    HeroOnDuel1 = player1:GetAssignedHero() 
    HeroOnDuel2 = player2:GetAssignedHero() 
    HeroOnDuel1.abs = HeroOnDuel1:GetAbsOrigin()
    HeroOnDuel2.abs = HeroOnDuel2:GetAbsOrigin()
    HeroOnDuel1:Stop()
    HeroOnDuel2:Stop()
    HeroOnDuel1:SetForwardVector(Vector(0,1,0))
    HeroOnDuel2:SetForwardVector(Vector(0,-1,0))
    FindClearSpaceForUnit(HeroOnDuel1, ARENA_TELEPORT_COORD_BOT, false) 
    FindClearSpaceForUnit(HeroOnDuel2, ARENA_TELEPORT_COORD_TOP, false) 
    player2:SetTeam(DOTA_TEAM_BADGUYS)
    HeroOnDuel2:SetTeam(DOTA_TEAM_BADGUYS)
    PlayerResource:UpdateTeamSlot(player2:GetPlayerID(), DOTA_TEAM_BADGUYS,true)
    HeroOnDuel1:Heal(9999,HeroOnDuel1)
    HeroOnDuel2:Heal(9999,HeroOnDuel2)
    HeroOnDuel1:GiveMana(9999)
    HeroOnDuel2:GiveMana(9999)
    ResetAllAbilitiesCooldown(HeroOnDuel1)
    ResetAllAbilitiesCooldown(HeroOnDuel2)
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
                    EndDuel(nil)
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
    print("winner",winner)
    CleanUnitsOnMap()
    if winner ~= nil then
        timerPopup:Stop()
        Timers:RemoveTimer("duelExpireTime")
        
        local heroWin = winner:GetAssignedHero()
        heroWin:ModifyGold(300-50*DuelNumber, true, DOTA_ModifyGold_Unspecified)
        winner.lumber = winner.lumber + 9 - DuelNumber
        FireGameEvent('cgm_player_lumber_changed', { player_ID = winner:GetPlayerID(), lumber = winner.lumber })
        heroWin:Stop()
        FindClearSpaceForUnit(heroWin, heroWin.abs, false) 
        
        local heroLoser = loser:GetAssignedHero()
        heroLoser:RespawnHero(false, false, false)
        FindClearSpaceForUnit(heroLoser, heroLoser.abs, false) 
        --GameRules:SendCustomMessage("#lia_Player"..PlayerResource:GetPlayerName(winner:GetPlayerID()).."#lia_duel_win", DOTA_TEAM_GOODGUYS, 0)
    else
        FindClearSpaceForUnit(HeroOnDuel1, HeroOnDuel1.abs, false) 
        FindClearSpaceForUnit(HeroOnDuel2, HeroOnDuel2.abs, false) 
        HeroOnDuel1:Heal(9999,HeroOnDuel1)
        HeroOnDuel2:Heal(9999,HeroOnDuel2)
        HeroOnDuel1:GiveMana(9999)
        HeroOnDuel2:GiveMana(9999)
        --GameRules:SendCustomMessage("#lia_duel_expiretime", DOTA_TEAM_GOODGUYS, 0)
    end
    HeroOnDuel2:GetPlayerOwner():SetTeam(DOTA_TEAM_GOODGUYS)
    HeroOnDuel2:SetTeam(DOTA_TEAM_GOODGUYS)
    PlayerResource:UpdateTeamSlot(HeroOnDuel2:GetPlayerOwner():GetPlayerID(), DOTA_TEAM_GOODGUYS,true)     
    HeroOnDuel1:AddNewModifier(HeroOnDuel1, nil, "modifier_stun_lua", {duration = -1})
    HeroOnDuel2:AddNewModifier(HeroOnDuel2, nil, "modifier_stun_lua", {duration = -1})
    if DuelNumber < math.floor(nPlayers / 2) then
        DuelNumber = DuelNumber + 1
        local firstPlayer = GetPlayerToDuel()
        local secondPlayer = GetPlayerToDuel()
        if firstPlayer and secondPlayer then
            print("Next duel", DuelNumber)
            print("firstPlayer",firstPlayer)
            print("secondPlayer",secondPlayer)
            Duel(firstPlayer,secondPlayer)
        else
            EndDuels()
        end

    else
        EndDuels()
    end
end

