
WAVE_SPAWN_COORD_LEFT    = Vector(-5550,  1900, 0)
WAVE_SPAWN_COORD_TOP     = Vector(-3450,  3800, 0)
ARENA_TELEPORT_COORD_TOP = Vector(-5024, -1360, 0)
ARENA_TELEPORT_COORD_BOT = Vector(-5024, -2360, 0)
ARENA_CENTER_COORD       = Vector(-5024, -1860, 0)
-- центр босс-арены - -5024, -1860

WAVE_NUM         = 1    --номер волны
WAVE_SPAWN_COUNT = {20,26,32,38,44,50,56,62}   --крипов на спавн
WAVE_MAX_COUNT   = {42,54,66,78,90,102,114,126}   --количество крипов и боссов с обоих спавнов
WAVE_DEAD_COUNT  = 0    --сколько уже умерло

GOLD_PER_WAVE = {0,12,12,12,12,12,15,15,18,18,18,18,21,24,24,27,27,30,30}

PRE_WAVE_TIME = 60 --время между волнами
PRE_DUEL_TIME = 30 --время перед дуэлью

MAX_LEVEL = 50

PLAYER_PLACE = {}

nDeathHeroes = 0

local DEBUG = true --при релизе обязательно поставить false!

-- Game end states
local NOT_ENDED		= 0
local VICTORIOUS	= 1
local DEFEATED		= 2

IsDuelOccured = false
IsDuel        = false

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
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetGoldTickTime(2)
	GameRules:SetGoldPerTick(1)
	GameRules:SetTreeRegrowTime(0)
    GameRules:SetHeroMinimapIconScale(0.5)
    GameRules:SetCreepMinimapIconScale(0.5)
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
    GameMode:SetBuybackEnabled(false)
    GameMode:SetTopBarTeamValuesVisible(false)
    GameMode:SetThink("onThink", self)
    GameMode:SetTowerBackdoorProtectionEnabled(false)
    GameMode:SetStashPurchasingDisabled(true)
     
    --listeners
    ListenToGameEvent('entity_killed', Dynamic_Wrap(LiA, 'onEntityKilled'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(LiA, 'onGameStateChange'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(LiA, 'onHeroPick'), self)

    CAMERA_GUY = CreateUnitByName("camera_guy", ARENA_CENTER_COORD, true, nil, nil, DOTA_TEAM_GOODGUYS) 

    TRIGGER_SHOP = Entities:FindByClassname(nil, "trigger_shop") --находим триггер отвечающий за работу магазина
    
    local destr = Entities:FindAllByClassname("npc_dota_tower")
    for i = 1, #destr do
        local destrName = destr[i]:GetUnitName()
		if destrName == "npc_dota_creature_barrel" or destrName == "small_barrel" or destrName == "barricades" or destrName == "arena_rock" or destrName == "tnt_barrel" then
			destr[i]:FindAbilityByName("barrel_no_health_bar"):SetLevel(1)
            destr[i]:SetTeam(DOTA_TEAM_GOODGUYS) 
            if destrName == "tnt_barrel" then
                destr[i]:FindAbilityByName("barrel_explosion"):SetLevel(1)
            end
		end
	end
end

function LiA:onThink()
    for i = 1, #PLAYER_PLACE do
        local player = PLAYER_PLACE[i]
        local hero = player:GetAssignedHero()
        player.rating = player.creeps * 2 + player.bosses * 20 + hero:GetLevel() * 30 + player.deaths * -15
        --print(player.rating,PlayerResource:GetPlayerName(player:GetPlayerID()))       
    end 
    table.sort(PLAYER_PLACE,function(a,b) return a.rating < b.rating end)
    return LiA.DeltaTime
end


function LiA:onHeroPick(keys)
    local player = PlayerResource:GetPlayer(keys.player-1) 
    local hero = EntIndexToHScript(keys.heroindex)
    player.creeps = 0
    player.bosses = 0
    player.deaths = 0
    player.rating = 0
    player.lumber = 3
    FireGameEvent('cgm_player_lumber_changed', { player_ID = hero:GetPlayerID(), lumber = player.lumber })
    table.insert(PLAYER_PLACE, player)
    PlayerResource:SetCustomTeamAssignment(keys.player-1, DOTA_TEAM_GOODGUYS)
    hero:SetTeam(DOTA_TEAM_GOODGUYS) 
    PlayerResource:SetGold(keys.player-1, 0, false) 
    if PlayerResource:HasRandomed(keys.player-1) then
        hero:SetGold(150,true)
    else
        hero:SetGold(100,true)
    end
end

function LiA:onGameStateChange()  
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        StartWaves()
    end
end


function LiA:onEntityKilled(keys)
    local ent = EntIndexToHScript(keys.entindex_killed)
    local ownerDied = ent:GetPlayerOwner()
    local ownerAtt = EntIndexToHScript(keys.entindex_attacker):GetPlayerOwner()
    if ent:IsRealHero() then
        Timers:CreateTimer(0.1,function() ownerDied:SetKillCamUnit(nil) end)
        if IsDuel then
            EndDuel(ownerAtt)
            print("winner",PlayerResource:GetPlayerName(ownerDied:GetPlayerID()))
        else
            ownerDied.deaths = ownerDied.deaths + 1
            nDeathHeroes = nDeathHeroes + 1
            if nDeathHeroes == HeroList:GetHeroCount() then
                GameRules:SetCustomVictoryMessage("#lose_message")
                GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
                --GameRules:ResetToHeroSelection()
            end
        end
    else
        if ent:GetUnitName() == tostring(WAVE_NUM).."_wave_creep"  then
            WAVE_DEAD_COUNT = WAVE_DEAD_COUNT + 1
            if ownerAtt ~= nil then
                ownerAtt.creeps = ownerAtt.creeps + 1
            end
        elseif ent:GetUnitName() == tostring(WAVE_NUM).."_wave_boss" then
            WAVE_DEAD_COUNT = WAVE_DEAD_COUNT + 1
            if ownerAtt ~= nil then
                ownerAtt.bosses = ownerAtt.bosses + 1
                ownerAtt.lumber = ownerAtt.lumber + 3
                FireGameEvent('cgm_player_lumber_changed', { player_ID = ownerAtt:GetPlayerID(), lumber = ownerAtt.lumber })
                PopupNumbers(ent, "gold", Vector(0,255,0), 3, 3, POPUP_SYMBOL_PRE_PLUS, nil)
            end
        end
if WAVE_DEAD_COUNT == WAVE_MAX_COUNT[CalcPlayers()] or (ent:GetUnitName() == tostring(WAVE_NUM).."_wave_boss" and WAVE_NUM % 5 ==0) then
            LiA._EndWave()
        end
    end
end

function StartWaves()
    Timers:CreateTimer(PRE_WAVE_TIME-3, function() 
            ShowCenterMessage("Волна №"..WAVE_NUM,5)
            return nil
        end
    )
    Timers:CreateTimer(PRE_WAVE_TIME, function() 
            LiA._SpawnWave()
            return nil
        end
    )  
end


function LiA:_SpawnWave()  
    local nPlayers = CalcPlayers()
    print(nPlayers,"players")
    CreateUnitByName(tostring(WAVE_NUM).."_wave_boss", WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    CreateUnitByName(tostring(WAVE_NUM).."_wave_boss", WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    local creepName = tostring(WAVE_NUM).."_wave_creep"
    for i = 1, WAVE_SPAWN_COUNT[nPlayers] do
        CreateUnitByName(creepName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName(creepName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-300, 300)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    end
    TRIGGER_SHOP:Disable()  
end

function LiA:_SpawnMegaboss()
    CreateUnitByName(tostring(WAVE_NUM).."_wave_boss", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS):SetForwardVector(Vector(0,-1,0))
    LiA._TeleportToArena()
    TRIGGER_SHOP:Disable() 
    BossCounter = 5
    Timers:CreateTimer(function()
        if BossCounter == 0 then
            DoWithAllHeroes(function(hero)
                hero:SetControllableByPlayer(hero:GetPlayerID(), true) 
            end)
            return nil
        else
            ShowCenterMessage(tostring(BossCounter),1)
            BossCounter = BossCounter - 1
            return 1
        end
    end)
end

function LiA:_EndWave()
    print("EndWave:started")
    WAVE_NUM = WAVE_NUM + 1
    WAVE_DEAD_COUNT = 0
    nDeathHeroes = 0
    if WAVE_NUM % 3 == 1 and not IsDuelOccured and CalcPlayers() > 1 then --проверка могут ли начаться дуэли
        print("EndWave:Duels started")
        StartDuels()
    else
        print("EndWave:wave")
        Timers:CreateTimer(PRE_WAVE_TIME-3, function() 
                ShowCenterMessage("Волна №"..tostring(WAVE_NUM),5)
                return nil
            end)
        if WAVE_NUM % 5 == 0 then --если босс
            Timers:CreateTimer(PRE_WAVE_TIME, function() 
                LiA._SpawnMegaboss()
                return nil
            end)
        else --обычные волны
            if WAVE_NUM % 5 == 1 then -- если только что был босс
                LiA._TeleportWithoutArena()
            end
            Timers:CreateTimer( PRE_WAVE_TIME, function() 
                LiA._SpawnWave()
                return nil
            end)
        end
        IsDuelOccured = false
        GoldAdd = WAVE_SPAWN_COUNT[CalcPlayers()] / CalcPlayers() * GOLD_PER_WAVE[WAVE_NUM]
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
end

function LiA:_TeleportToArena() --Телепорт на арену
	DoWithAllHeroes(function(hero)
		hero.abs = hero:GetAbsOrigin() 
        hero:SetControllableByPlayer(hero:GetPlayerID(), false) 
        hero:Stop()
        hero:SetForwardVector(Vector(0, 1, 0))
        FindClearSpaceForUnit(hero, ARENA_TELEPORT_COORD_BOT + Vector(RandomInt(-200,200),RandomInt(-50,50),0), false)
        hero:Heal(9999,hero)
        hero:GiveMana(9999)
        PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero) --перемещаем камеру игрока на арену
	end)  
    Timers:CreateTimer(3,function() --через несколько секунд камеру "отцепляем" 
        DoWithAllHeroes(function(hero)
           PlayerResource:SetCameraTarget(hero:GetPlayerID() ,nil)    
        end)
    end)
end

function LiA:_TeleportWithoutArena() --Телепорт с арены
    DoWithAllHeroes(function(hero)
        hero:Stop()
        FindClearSpaceForUnit(hero, hero.abs, false)
        PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero) --перемещаем камеру игрока к юниту   
    end)
    Timers:CreateTimer(2,function() --через время камеру "отцепляем" от героя
        DoWithAllHeroes(function(hero)
           PlayerResource:SetCameraTarget(hero:GetPlayerID() ,nil)    
        end)
    end)
end

function StartDuels()
    DuelNumber = 1
    Timers:CreateTimer(10,function()
        IsDuel = true
        TRIGGER_SHOP:Disable() 
        DoWithAllHeroes(function(hero)
            hero:SetControllableByPlayer(hero:GetPlayerID(), false) 
        end)
        GameRules:SendCustomMessage("#lia_duel <br>".."#lia_Player"..PlayerResource:GetPlayerName(PLAYER_PLACE[1]:GetPlayerID()).."#lia_duel_vs"..PlayerResource:GetPlayerName(PLAYER_PLACE[2]:GetPlayerID()), DOTA_TEAM_GOODGUYS, 0)
        Duel(PLAYER_PLACE[1],PLAYER_PLACE[2])
        print("firstPlayer",PLAYER_PLACE[1])
        print("secondPlayer",PLAYER_PLACE[2])
    end)
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
    PlayerResource:SetCustomTeamAssignment(player2:GetPlayerID(), 7)
    HeroOnDuel2:SetTeam(7)
    HeroOnDuel1:Heal(9999,HeroOnDuel1)
    HeroOnDuel2:Heal(9999,HeroOnDuel2)
    HeroOnDuel1:GiveMana(9999)
    HeroOnDuel2:GiveMana(9999)
    ResetAllAbilitiesCooldown(HeroOnDuel1)
    ResetAllAbilitiesCooldown(HeroOnDuel2)
    DuelCounter = 5
    Timers:CreateTimer(function()
        if DuelCounter == 0 then
            HeroOnDuel1:SetControllableByPlayer(HeroOnDuel1:GetPlayerID(), true)
            HeroOnDuel2:SetControllableByPlayer(HeroOnDuel2:GetPlayerID(), true)
            Timers:CreateTimer("duelExpireTime",{ --таймер дуэли
                useGameTime = false,
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

function EndDuel(winner)
    if winner ~= nil then
        Timers:RemoveTimer("duelExpireTime")
        local heroWin = winner:GetAssignedHero()
        heroWin:ModifyGold(300-50*DuelNumber, true, DOTA_ModifyGold_Unspecified)
        winner.lumber = winner.lumber + 9 - DuelNumber
        FireGameEvent('cgm_player_lumber_changed', { player_ID = winner:GetPlayerID(), lumber = winner.lumber })
        heroWin:Stop()
        FindClearSpaceForUnit(heroWin, heroWin.abs, false) 
        heroWin:SetControllableByPlayer(heroWin:GetPlayerID(), false)
        PlayerResource:SetCustomTeamAssignment(HeroOnDuel2:GetPlayerOwnerID(), DOTA_TEAM_GOODGUYS)
        HeroOnDuel2:SetTeam(DOTA_TEAM_GOODGUYS)   
        GameRules:SendCustomMessage("#lia_Player"..PlayerResource:GetPlayerName(winner:GetPlayerID()).."#lia_duel_win", DOTA_TEAM_GOODGUYS, 0)
    else
        PlayerResource:SetCustomTeamAssignment(HeroOnDuel2:GetPlayerOwnerID(), DOTA_TEAM_GOODGUYS)
        HeroOnDuel2:SetTeam(DOTA_TEAM_GOODGUYS)   
        FindClearSpaceForUnit(HeroOnDuel1, HeroOnDuel1.abs, false) 
        FindClearSpaceForUnit(HeroOnDuel2, HeroOnDuel2.abs, false) 
        HeroOnDuel1:Heal(9999,HeroOnDuel1)
        HeroOnDuel2:Heal(9999,HeroOnDuel2)
        HeroOnDuel1:GiveMana(9999)
        HeroOnDuel2:GiveMana(9999)
        GameRules:SendCustomMessage("#lia_duel_expiretime", DOTA_TEAM_GOODGUYS, 0)
    end
    if DuelNumber < math.floor(CalcPlayers() / 2) then
        DuelNumber = DuelNumber + 1
        print(DuelNumber,"next duel")
        GameRules:SendCustomMessage("#lia_duel_next <br>".."#lia_Player"..PlayerResource:GetPlayerName(PLAYER_PLACE[DuelNumber*2-1]:GetPlayerID()).."#lia_duel_vs"..PlayerResource:GetPlayerName(PLAYER_PLACE[DuelNumber*2]:GetPlayerID()), DOTA_TEAM_GOODGUYS, 0)
        Duel(PLAYER_PLACE[DuelNumber*2-1],PLAYER_PLACE[DuelNumber*2])
    else
        print(DuelNumber,"end duels")
        IsDuel = false
        IsDuelOccured = true
        WAVE_NUM = WAVE_NUM - 1
        DoWithAllHeroes(function(hero)
            hero:SetControllableByPlayer(hero:GetPlayerID(), true) 
        end)
        LiA:_EndWave()
    end
end