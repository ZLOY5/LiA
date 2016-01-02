
_G.SURVIVAL_STATE_PRE_GAME = 0
_G.SURVIVAL_STATE_PRE_ROUND_TIME = 1
_G.SURVIVAL_STATE_PRE_DUEL_TIME = 2
_G.SURVIVAL_STATE_ROUND_WAVE = 3
_G.SURVIVAL_STATE_ROUND_MEGABOSS = 4
_G.SURVIVAL_STATE_ROUND_FINALBOSS = 5
_G.SURVIVAL_STATE_DUEL_TIME = 6
_G.SURVIVAL_STATE_POST_GAME = 7

_G.WAVE_SPAWN_COORD_LEFT    = Vector(-5459.35,  1950.99, 0)
_G.WAVE_SPAWN_COORD_TOP     = Vector(-3137.9,  3888, 0) 
_G.ARENA_TELEPORT_COORD_TOP = Vector(-3317, -1495.29, 0)
_G.ARENA_TELEPORT_COORD_BOT = Vector(-3317, -2542, 0)
_G.ARENA_CENTER_COORD       = Vector(-3317, -2018.645, 0)


------------------------------------------------------------------------------------------------

if Survival == nil then
    print("Survival")
    
	_G.Survival = class({})
end

------------------------------------------------------------------------------------------------

require('survival/events')
require('survival/duels')
require('survival/finalBoss')
require('survival/utils')

------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_16_wave_debuff", "survival/modifier_16_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_17_wave_debuff", "survival/modifier_17_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_18_wave_debuff", "survival/modifier_18_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_19_wave_debuff", "survival/modifier_19_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------------------------------

function Survival:InitSurvival()
    Survival = self

    _G.WORLD_BOUNDS_BOSS_MIN = Entities:FindByName(nil, "world_bounds_boss_min"):GetAbsOrigin()
    _G.WORLD_BOUNDS_BOSS_MAX = Entities:FindByName(nil, "world_bounds_boss_max"):GetAbsOrigin()
    _G.WORLD_BOUNDS_MIN = Entities:FindByName(nil, "world_bounds_min"):GetAbsOrigin()
    _G.WORLD_BOUNDS_MAX = Entities:FindByName(nil, "world_bounds_max"):GetAbsOrigin()
    _G.ARENA_TOP_RIGHT_CORNER = Entities:FindByName(nil, "arena_top_right_corner"):GetAbsOrigin()
    _G.ARENA_LEFT_BOTTOM_CORNER = Entities:FindByName(nil, "arena_left_bottom_corner"):GetAbsOrigin()
    _G.BOSS_ARENA_CENTER = Entities:FindByName(nil, "boss_arena_center"):GetAbsOrigin()

    self.tHeroes = {}
	self.nRoundNum = 0

    self.nHeroCount = 0
	self.nDeathHeroes = 0
	self.nDeathCreeps = 0
	self.nWaveSpawnCount = {20,26,32,38,44,50,56,62}   --крипов на спавн
	self.nWaveMaxCount = {42,54,66,78,90,102,114,126}

	self.nGoldPerWave = {12,12,12,12,12,15,15,18,18,18,18,18,21,24,24,27,27,30,30}

    self.flExpFix = {0.8, 0.9, 1., 1.1, 1.2, 1.3, 1.4, 1.5}
    
    self.IsAllRandom = false
    self.IsExtreme = false
    self.IsLight = false

    self.flExtremeExpMultiplier = -0.3
    self.flLightExpMultiplier = 0.2

    self.flExtremeGoldMultiplier = -0.3
    self.flLightGoldMultiplier = 0.8

    self.nEqualGoldPool = 0
	self.barrelExplosions = 0
    
	self.nPreRoundTime = 60
	self.nPreDuelTime = 30
    self.nDuelTime = 120

    self.nRoundDisableGoldTime = 120

    self.State = SURVIVAL_STATE_PRE_GAME

    self.IsDuelOccured = false
	--self.IsDuel = false

	GameRules:SetCustomVictoryMessage("#victory_message")
    GameRules:SetHideKillMessageHeaders(true)
    GameRules:SetTreeRegrowTime(60)
    GameRules:SetHeroRespawnEnabled(false)

    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 ) 

    --Tutorial:SetTimeFrozen(true)

    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetThink("onThink", self)
	--LiA_AIcreeps
	GameMode:SetThink("onThinkAIcreepsUpdate", self)
    GameMode:SetFogOfWarDisabled(true)

    for playerID = 0, DOTA_MAX_PLAYERS-1 do
        PlayerResource:SetGold(playerID, 0, true)
        PlayerResource:SetGold(playerID, 100, false)
    end

    GameMode:SetModifyExperienceFilter(Dynamic_Wrap(Survival, "ExperienceFilter"), self)
    GameMode:SetModifyGoldFilter(Dynamic_Wrap(Survival, "GoldFilter"), self)

    ListenToGameEvent('entity_killed', Dynamic_Wrap(Survival, 'OnEntityKilled'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Survival, 'OnPlayerPickHero'), self)
    ListenToGameEvent('player_chat', Dynamic_Wrap(Survival, 'OnPlayerChat'), self)
    
    GameMode:SetContextThink( "AIThink", AIThink , 3)
    self.AICreepCasts = 0
    self.AIMaxCreepCasts = 2

    self.hHealer = Entities:FindByName(nil,"lia_trigger_healer")
    if not self.hHealer then 
        print("Survival: Cant find lia_trigger_healer")
    end

    SetRuneSpawnRegion("rectangle",ARENA_LEFT_BOTTOM_CORNER,ARENA_TOP_RIGHT_CORNER)
    StartRunesSpawn()
    --hBounds = SpawnEntityFromTableSynchronous("world_bounds", {Min = Vector(0,0,0),Max = Vector(1000,1000,0)})
    --DeepPrintTable(hBounds)
end

function AIThink()
    --print("CleanAICasts")
    local nHeroesAlive = Survival.nHeroCount - Survival.nDeathHeroes

    Survival.AIMaxCreepCasts = math.ceil(nHeroesAlive/2)

    Survival.AICreepCasts = 0
    return 3
end

function Survival:GoldFilter(filterTable)
    --PrintTable("GoldFilter",filterTable)
    if filterTable.reason_const == DOTA_ModifyGold_HeroKill or filterTable.reason_const == DOTA_ModifyGold_SharedGold then 
        return false 
    end
    return true
end

function Survival:ExperienceFilter(filterTable)
    --PrintTable("ExperienceFilter",filterTable)
    if Survival.State == SURVIVAL_STATE_DUEL_TIME then --на дуэлях опыта не даем
        return false
    end

    local expMultiplier = self.flExpFix[self.nHeroCount] -- коррекция получаемого опыта в зависимости от кол-ва героев в игре
    
    if self.IsExtreme then --множители опыта для экстрима или лайта
        expMultiplier = expMultiplier + self.flExtremeExpMultiplier
    elseif self.IsLight then
        expMultiplier = expMultiplier + self.flLightExpMultiplier
    end

    filterTable.experience = filterTable.experience * expMultiplier
    return true

end

function Survival:onThink()
    GameRules:SetTimeOfDay( 0.5 )
	local hero
    for i = 1, #self.tHeroes do
        hero = self.tHeroes[i]
        hero.rating = math.floor(hero.percUlu * 7 + .5) + hero.creeps * 2 + hero.bosses * 20 + hero.deaths * -15 + hero:GetLevel() * 30 - 30
    end 
    table.sort(self.tHeroes,function(a,b) return a.rating > b.rating end)

    local data = self:GetDataForSend()

    if not (Survival.State == SURVIVAL_STATE_DUEL_TIME) then
        if #self.tHeroes ~= 0 then
            CustomGameEventManager:Send_ServerToAllClients( "upd_action", data )
        end
    end
	
	-- update lumber in hud
	local playerID
    local playersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    for i = 1, playersCount do 
        playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
        --local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local dataL = self:GetDataForSendUlu(true, nil,playerID,nil,nil,nil)
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "upd_action_lumber", dataL )
		--CustomGameEventManager:Send_ServerToAllClients( "upd_action_lumber", dataL )
	end
	--
	-- update for fallen count get damage
	local ndata
    for i = 1, #self.tHeroes do
        hero = self.tHeroes[i]
		if hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
			if hero.alldmgActive then
				ndata = {count = hero.alldmg}
				CustomGameEventManager:Send_ServerToPlayer( hero:GetPlayerOwner(), "upd_action_fallen", ndata )
			end
		end
	end
	--
	--
    return 0.5
end

function Survival:_TeleportHeroesWithoutBossArena()
    DoWithAllHeroes(function(hero)
        hero:Stop()
        FindClearSpaceForUnit(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerID(),hero.abs)
    end)
end

function Survival:_GiveRoundBounty()
    print(self.nHeroCount)
    goldBounty = self.nWaveSpawnCount[self.nHeroCount] / self.nHeroCount * self.nGoldPerWave[self.nRoundNum]
    lumberBounty = 3 + self.nRoundNum

    if self.IsExtreme then
        goldBounty = goldBounty * (1 + self.flExtremeGoldMultiplier)
    elseif self.IsLight then
        goldBounty = goldBounty * (1 + self.flLightGoldMultiplier)
    end

    if self.nRoundNum % 5 == 0 then
        goldBounty = goldBounty + (self.nRoundNum * 40)
        lumberBounty = lumberBounty + 5
    end

    if self.IsEqualGold then
        goldBounty = goldBounty + (self.nEqualGoldPool / self.nHeroCount)
    end

    DoWithAllHeroes(function(hero)
        local oldGold = hero:GetGold()
        hero:ModifyGold(goldBounty, false, DOTA_ModifyGold_Unspecified)
        hero.lumber = hero.lumber + lumberBounty
        print(hero:GetUnitName(),"gold",oldGold," --> ",tostring(hero:GetGold()))
    end)
end

function Survival:EndRound()
    print("Survival:EndRound",self.nRoundNum)
    self.nDeathCreeps = 0
    self.nDeathHeroes = 0

    Timers:RemoveTimer("DisableGoldTimer")
    GameRules:SetGoldPerTick(1)

    Timers:RemoveTimer("lateWaveDebuffs")
    DoWithAllHeroes(function(hero)
        hero:RemoveModifierByName("modifier_"..self.nRoundNum.."_wave_debuff")
    end)
    
    Timers:CreateTimer(1,function()
        CleanUnitsOnMap()

        DoWithAllHeroes(function(hero)
            if hero:IsAlive() then
                hero:Purge(false, true, false, true, false)
                hero:Heal(9999,hero)
                hero:GiveMana(9999)
            end
        end)
    
        RespawnAllHeroes() 

        if Survival.State == SURVIVAL_STATE_ROUND_MEGABOSS then
            print("TeleportHeroesWithoutBossArena")
            SetRuneSpawnRegion("rectangle",ARENA_LEFT_BOTTOM_CORNER,ARENA_TOP_RIGHT_CORNER)
            ChangeWorldBounds(WORLD_BOUNDS_MAX,WORLD_BOUNDS_MIN)
            ClearBossArenaByItems()
            Survival:_TeleportHeroesWithoutBossArena()
        end

        EnableShop()
        
        if self.nRoundNum % 3 == 0 and not self.IsDuelOccured and self.nHeroCount > 1 then
            Survival:StartDuels()
        else

            Survival:_GiveRoundBounty()
            Survival:PrepareNextRound()
        end
    end)
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
    
    print("Next round - ", self.nRoundNum)

    nPlayersReady = 0
    for _,player in pairs(LiA.tPlayers) do
        player.readyToWave = false
    end
    LiA.bForceRoundEnabled = true

    self.IsDuelOccured = false
    Survival.State = SURVIVAL_STATE_PRE_ROUND_TIME

    Survival:_TimerMessage()

    Timers:CreateTimer("StartRoundTimer",
        {
            endTime = self.nPreRoundTime-3, 
            callback = function() Survival:StartRound() end
        }
    )

    self.hHealer:Enable()

    local creepName = tostring(self.nRoundNum).."_wave_creep"
    local bossName = tostring(self.nRoundNum).."_wave_boss"
    if self.IsExtreme then 
        creepName = creepName.."_extreme"
        bossName = bossName.."_extreme"
    end
    PrecacheUnitByNameAsync(creepName, function(...) end)
    PrecacheUnitByNameAsync(bossName, function(...) end)

    for _,hero in pairs(self.tHeroes) do
        if hero.prorogueHide then 
            self:HideHero(hero)
        elseif hero.prorogueUnhide then
            self:UnhideHero(hero)
        end
    end
end

--------------------------------------------------------------------------------------------------

function Survival:_TeleportHeroesToBossArena()
    local length = 70 * self.nHeroCount
    DoWithAllHeroes(function(hero)
        hero.abs = hero:GetAbsOrigin() 
        hero:Stop()
        hero:SetForwardVector(Vector(0, 1, 0))
        FindClearSpaceForUnit(hero, ARENA_TELEPORT_COORD_BOT + Vector(RandomInt(-length,length),RandomInt(-50,50),0), false)

        hero:Heal(9999,hero)
        hero:GiveMana(9999)
        hero:AddNewModifier(hero, nil, "modifier_stun_lua", {duration = 5})
    end) 
    SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD+Vector(0,-100,0)) 
end

function Survival:_SpawnMegaboss()
    print("Spawn megaboss")

    Survival.State = SURVIVAL_STATE_ROUND_MEGABOSS

    local boss
    if self.nRoundNum == 20 then
    	Survival.State = SURVIVAL_STATE_ROUND_FINALBOSS
        boss = CreateUnitByName("orn_megaboss", ARENA_TELEPORT_COORD_TOP, true, nil, nil, DOTA_TEAM_NEUTRALS)
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
	--AIcreeps
    Survival:AICreepsDefault()
    Survival.State = SURVIVAL_STATE_ROUND_WAVE
    
    self.nHeroCountCreepsSpawned = self.nHeroCount --чтобы уберечь от багов при изменении кол-ва героев во время волны(кто-то взял героя после старта волны например)
    
    local unit1, unit2, boss1, boss2
    local creepName = tostring(self.nRoundNum).."_wave_creep"
    local bossName = tostring(self.nRoundNum).."_wave_boss"
    if self.IsExtreme then 
        creepName = creepName.."_extreme"
        bossName = bossName.."_extreme"
    end
    
    local pathEffect = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
    
    boss1 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    boss2 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss1)
    ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss2)
    boss1:EmitSound("DOTA_Item.BlinkDagger.Activate")
    boss2:EmitSound("DOTA_Item.BlinkDagger.Activate")
    
    Survival:AICreepsInsertToTable(boss1,boss2)
    
    if self.IsEqualGold then
        self.nEqualGoldPool = self.nEqualGoldPool + boss1:GetGoldBounty()*2
        boss1:SetMinimumGoldBounty(0)
        boss2:SetMinimumGoldBounty(0)
        boss1:SetMaximumGoldBounty(0)
        boss2:SetMaximumGoldBounty(0)
    end

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
            
            Survival:AICreepsInsertToTable(unit1,unit2)
            
            if self.IsEqualGold then
                self.nEqualGoldPool = unit1:GetGoldBounty()*2
                unit1:SetMinimumGoldBounty(0)
                unit2:SetMinimumGoldBounty(0)
                unit1:SetMaximumGoldBounty(0)
                unit2:SetMaximumGoldBounty(0)
            end

            spawnCount = spawnCount + 1
            if spawnCount == self.nWaveSpawnCount[self.nHeroCountCreepsSpawned] then
                return nil
            else
                return tick
            end
        end
    ) 

    if self.nRoundNum >= 16 then 
        Timers:CreateTimer("lateWaveDebuffs",
            {
                endTime = 1, 
                callback = LateWaveDebuffs
            }
        )
    end
end

function LateWaveDebuffs() 
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 9999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL-DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,unit in pairs(units) do 
        if Survival.nRoundNum < 18 then 
            if unit:IsRealHero() then 
                unit:AddNewModifier(unit, nil, "modifier_"..Survival.nRoundNum.."_wave_debuff", nil)
            end
        else
            unit:AddNewModifier(unit, nil, "modifier_"..Survival.nRoundNum.."_wave_debuff", nil)
        end
    end
    return 1
end

function Survival:StartRound()
    if self.nHeroCount == 0 then 
        GameRules:SetCustomVictoryMessage("#lose_message")
        Survival:EndGame(DOTA_TEAM_BADGUYS)
        return   
    end

    self.hHealer:Disable()

    Timers:CreateTimer("DisableGoldTimer",
        {
            endTime = self.nRoundDisableGoldTime, 
            callback = function() GameRules:SetGoldPerTick(0) print("Survival: Gold tick disabled after "..self.nRoundDisableGoldTime.." seconds of round") end
        }
    )

    LiA.bForceRoundEnabled = false
    
    CustomGameEventManager:Send_ServerToAllClients( "round_start", {round_number = self.nRoundNum} )
    
    Timers:CreateTimer(3,function()
            DisableShop()
            
            if self.nRoundNum % 5 == 0 then -- мегабоосс
                CleanUnitsOnMap()
                SetRuneSpawnRegion("circle",ARENA_CENTER_COORD,nil)
                ChangeWorldBounds(WORLD_BOUNDS_BOSS_MAX,WORLD_BOUNDS_BOSS_MIN)
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

function Survival:GetDataForSendUlu(only_upd, done, pid, need, finish, name)
	--local tPlayersId = {}
	--local tlumber = {}
	--local tpercUlu = {}
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	--
    local data
	if hero then
		data =
			{
				--PlayersId = tPlayersId,
				Lumber = hero.lumber or 0,
				PercUlu = hero.percUlu or 0,
				UluPlayerId = pid,
				UluDone = done,
				UluNeed = need,
				OnlyUpd = only_upd,
				Finish = finish,
				Name = name,
			}
	else
		data =
			{
				--PlayersId = tPlayersId,
				Lumber = 0,
				PercUlu = 0,
				UluPlayerId = pid,
				UluDone = done,
				UluNeed = need,
				OnlyUpd = only_upd,
				Finish = finish,
				Name = name,
			}
	
	end
	
	
    --[[local playersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    for i = 1, playersCount do 
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		table.insert(tPlayersId,playerID)
        if hero then
            table.insert(tlumber,hero.lumber or 0)
			table.insert(tpercUlu,hero.percUlu or 0)
        else 
            table.insert(tlumber,0)
			table.insert(tpercUlu,0)
        end
		--hero.percUlu
	end
	]]

    return data
end

function Survival:GetDataForSend()
    local tPlayersId = {}
    local tKillsCreeps = {}
    local tKillsBosses = {}
	local tPercUlu = {}
    local tDeaths = {}
    local tRating = {}
    --[[
    -- tHeroes need to be sorted
    --
    for i = 1, #self.tPlayers do
        local hero = self.tHeroes[i]
        table.insert(tPlayersId,hero:GetPlayerID())
        table.insert(tKillsCreeps,hero.creeps or 0)
        table.insert(tKillsBosses,hero.bosses or 0)
        table.insert(tDeaths,hero.deaths or 0)
        table.insert(tRating,hero.rating or 0)
    end]]

    local playersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    for i = 1, playersCount do 
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        table.insert(tPlayersId,playerID)
        if hero then
            table.insert(tKillsCreeps,hero.creeps or 0)
            table.insert(tKillsBosses,hero.bosses or 0)
			table.insert(tPercUlu,hero.percUlu or 0)
            table.insert(tDeaths,hero.deaths or 0)
            table.insert(tRating,hero.rating or 0)
        else 
            table.insert(tKillsCreeps,0)
            table.insert(tKillsBosses,0)
			table.insert(tPercUlu,0)
            table.insert(tDeaths,0)
            table.insert(tRating,0)
        end
    end
    
    local data =
        {
            PlayersId = tPlayersId,
            KillsCreeps = tKillsCreeps,
            KillsBosses = tKillsBosses,
            Deaths = tDeaths,
            Rating = tRating,
			PercUlu = tPercUlu,
            barrelExplosions = self.barrelExplosions,
        }
    return data
end

function Survival:EndGame(teamWin)
    local GameMode = GameRules:GetGameModeEntity()
    --local data = LiA:GetDataForSend()
    local dataHide = 
    {
        visible = false,
    }
    --print("       data", data)
    CustomGameEventManager:Send_ServerToAllClients( "upd_action_hide", dataHide )
    GameMode:SetContextThink( "EndGameCon", EndGameCon , 0.5)
    GameRules:SetGameWinner(teamWin)  
end

function EndGameCon()
    local data = Survival:GetDataForSend()
    CustomGameEventManager:Send_ServerToAllClients( "upd_action_end", data )
    return nil --0.5
end
