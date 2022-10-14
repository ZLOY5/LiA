
_G.SURVIVAL_STATE_PRE_GAME = 0
_G.SURVIVAL_STATE_PRE_ROUND_TIME = 1
_G.SURVIVAL_STATE_PRE_DUEL_TIME = 2
_G.SURVIVAL_STATE_ROUND_WAVE = 3
_G.SURVIVAL_STATE_ROUND_MEGABOSS = 4
_G.SURVIVAL_STATE_ROUND_FINALBOSS = 5
_G.SURVIVAL_STATE_DUEL_TIME = 6
_G.SURVIVAL_STATE_POST_GAME = 7

_G.WAVE_SPAWN_COORD_LEFT    = Vector(-1770,  1177, 0)
_G.WAVE_SPAWN_COORD_TOP     = Vector(108,  3068, 0) 
_G.ARENA_TELEPORT_COORD_TOP = Vector(-7, -2004, 0)
_G.ARENA_TELEPORT_COORD_BOT = Vector(-7, -3050, 0)
_G.ARENA_CENTER_COORD       = Vector(-7, -2506, 0)


------------------------------------------------------------------------------------------------

if Survival == nil then
    print("Survival")
    
	_G.Survival = class({})
end

------------------------------------------------------------------------------------------------

require('survival/events')
require('survival/duels')
require('survival/finalBoss')
require('survival/fightrecap')
require('survival/utils')

------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_16_wave_debuff", "survival/modifier_16_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_17_wave_debuff", "survival/modifier_17_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_18_wave_debuff", "survival/modifier_18_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_19_wave_debuff", "survival/modifier_19_wave_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_megaboss_three_stats", "units/modifier_megaboss_three_stats.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_ultimate_upgrade", "items/modifiers/modifier_ultimate_upgrade.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------------------------------

function Survival:InitSurvival()
    _G.WORLD_BOUNDS_BOSS_MIN = Entities:FindByName(nil, "world_bounds_boss_min"):GetAbsOrigin()
    _G.WORLD_BOUNDS_BOSS_MAX = Entities:FindByName(nil, "world_bounds_boss_max"):GetAbsOrigin()
    _G.WORLD_BOUNDS_MIN = Entities:FindByName(nil, "world_bounds_min"):GetAbsOrigin()
    _G.WORLD_BOUNDS_MAX = Entities:FindByName(nil, "world_bounds_max"):GetAbsOrigin()
    _G.ARENA_TOP_RIGHT_CORNER = Entities:FindByName(nil, "arena_top_right_corner"):GetAbsOrigin()
    _G.ARENA_LEFT_BOTTOM_CORNER = Entities:FindByName(nil, "arena_left_bottom_corner"):GetAbsOrigin()
    _G.BOSS_ARENA_CENTER = Entities:FindByName(nil, "boss_arena_center"):GetAbsOrigin()

    self.tHeroes = {}
	self.nRoundNum = 0


	self.nDeathCreeps = 0
    self.nCreepsSpawned = 0
	self.nWaveSpawnCount = {20,26,32,38,44,50,56,62}   --крипов на спавн
	self.nWaveMaxCount = {42,54,66,78,90,102,114,126}

	self.nGoldPerWave = {12,12,12,12,12,15,15,18,18,18,18,18,21,24,24,27,27,30,30}

    self.flExpFix = {0.75, 1, 1.15, 1.2, 1.25, 1.29, 1.32, 1.3}
    
    self.IsAllRandom = false
    self.IsExtreme = not not string.find(GetMapName(),"extreme")
    self.IsLight = not not string.find(GetMapName(),"light")

    self.flExtremeExpMultiplier = -0.3
    self.flLightExpMultiplier = 0.2

    self.flExtremeGoldMultiplier = -0.3
    self.flLightGoldMultiplier = 0.8

    self.nEqualGoldPool = 0
	self.barrelExplosions = 0
    
    self.nPreFinalTime = 90
	self.nPreRoundTime = 360
	self.nPreDuelTime = 30
    self.nDuelTime = 120

    -- Золото за быстрое прохождение
    self.nfastWaveTime = 15
    self.nfastBossTime = 30
    self.nfastRoundGold = 60


    self.State = SURVIVAL_STATE_PRE_GAME

    self.IsDuelOccured = false

    GameRules:SetUseCustomHeroXPValues(true)

	GameRules:SetCustomVictoryMessage("#victory_message")
    GameRules:SetHideKillMessageHeaders(true)
    GameRules:SetTreeRegrowTime(60)
    GameRules:SetHeroRespawnEnabled(false)

    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 ) 

    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetThink("onThink", self)
	--LiA_AIcreeps
	GameMode:SetThink("onThinkAIcreepsUpdate", self)
    GameMode:SetFogOfWarDisabled(true)

    --for playerID = 0, DOTA_MAX_PLAYERS-1 do
    --    PlayerResource:SetGold(playerID, 0, true)
    --    PlayerResource:SetGold(playerID, 500, false)
    --end

    GameMode:SetSelectionGoldPenaltyEnabled(false)

    GameMode:SetModifyExperienceFilter(Dynamic_Wrap(Survival, "ExperienceFilter"), self)
    GameMode:SetModifyGoldFilter(Dynamic_Wrap(Survival, "GoldFilter"), self)
    GameMode:SetExecuteOrderFilter(Dynamic_Wrap(Survival, "OrderFilter"), self)
    GameMode:SetItemAddedToInventoryFilter(Dynamic_Wrap(Survival, "ItemAddFilter"), self)
    GameMode:SetTPScrollSlotItemOverride("item_lia_healing_ward")


    ListenToGameEvent('entity_killed', Dynamic_Wrap(Survival, 'OnEntityKilled'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(Survival, 'OnPlayerPickHero'), self)
    ListenToGameEvent('player_chat', Dynamic_Wrap(Survival, 'OnPlayerChat'), self)
    ListenToGameEvent('entity_hurt', Dynamic_Wrap(Survival, 'OnEntityHurt'), self)
    ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(Survival, 'OnAbilityUsed'), self)

    
    GameMode:SetContextThink( "AIThink", AIThink , 3)
    self.AICreepCasts = 0
    self.AIMaxCreepCasts = 2

    self.hHealer = Entities:FindByName(nil,"lia_trigger_healer")
    if not self.hHealer then 
        print("Survival: Cant find lia_trigger_healer")
    end

    SetRuneSpawnRegion("rectangle",ARENA_LEFT_BOTTOM_CORNER,ARENA_TOP_RIGHT_CORNER)
    StartRunesSpawn()

    for i = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidTeamPlayerID(i) then
            CustomPlayerResource:InitPlayer(i)
        end
    end

    FightRecap:Init()

    --GameMode:SetContextThink("RandomGold",ThinkGoldGuard,0.1)
    --PlayerResource.RandomGoldReduced = {}
end

--[[function ThinkGoldGuard()
    for i = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidTeamPlayerID(i) and PlayerResource:GetSelectedHeroName(i) ~= "" and not PlayerResource.RandomGoldReduced[i] then
            if PlayerResource:HasRandomed(i) then
                PlayerResource:SetGold(i, 180, false)
            else
                PlayerResource:SetGold(i, 130, false)
            end
            PlayerResource.RandomGoldReduced[i] = true
        end
    end
    
    return 0.1
end]]

function AIThink()
    --print("CleanAICasts")
    local nHeroesAlive = Survival:GetHeroCount(true)

    Survival.AIMaxCreepCasts = math.ceil(nHeroesAlive/2)

    Survival.AICreepCasts = 0
    return 3
end

function Survival:OrderFilter(filterTable)
    --DeepPrint(filterTable)

    if filterTable.order_type == DOTA_UNIT_ORDER_GLYPH then
        return false
    end

    if filterTable.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then


        if Survival.State ~= SURVIVAL_STATE_PRE_GAME and Survival.State ~= SURVIVAL_STATE_PRE_ROUND_TIME and Survival.State ~= SURVIVAL_STATE_PRE_DUEL_TIME then
            --print(filterTable.units["0"])
            local hero = PlayerResource:GetSelectedHeroEntity(filterTable.issuer_player_id_const)
            if hero:GetNumItemsInStash() == 6 then
                return false
            end
        end
    end

    if filterTable.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH then
        if Survival.State ~= SURVIVAL_STATE_PRE_ROUND_TIME and Survival.State ~= SURVIVAL_STATE_PRE_DUEL_TIME then
            return false
        end
    end

    if filterTable.order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
        local item = EntIndexToHScript(filterTable.entindex_ability)
        local hero = EntIndexToHScript(filterTable.units["0"])
        local itemName = item:GetAbilityName()
        if itemName == "item_lia_knight_shield" or itemName == "item_lia_knight_cuirass" then
            if filterTable.entindex_target <= 5 
            and ( hero:HasItemInInventory("item_lia_knight_shield",false,item) or hero:HasItemInInventory("item_lia_knight_cuirass",false,item) ) then
                SendErrorMessage(hero:GetPlayerID(), "#lia_hud_error_cant_have_two_items_retdmg")
                return false
            end
        end
    end

    if filterTable.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM  then
        local hero = EntIndexToHScript(filterTable.units["0"])
        local itemContainer = EntIndexToHScript(filterTable.entindex_target)
        local item
        
        if itemContainer then
            item = itemContainer:GetContainedItem()
        end

        if not item then return end

        local itemName = item:GetAbilityName()
        local notPickableRunes = {"item_lia_rune_of_healing", "item_lia_rune_of_mana", "item_lia_rune_of_restoration", "item_lia_rune_of_speed", "item_lia_rune_of_lifesteal", "item_lia_rune_of_protection"}
        if Survival.State == SURVIVAL_STATE_PRE_DUEL_TIME then
            for i = 1,#notPickableRunes do
                print(notPickableRunes[i])
                if itemName == notPickableRunes[i] then
                    SendErrorMessage(hero:GetPlayerID(), "#lia_cant_pick_this_rune_preduel")
                    return false
                end
            end
        end
    end


    return true
end

function Survival:ItemAddFilter(filterTable)
    --DeepPrint(filterTable)
    local item = EntIndexToHScript(filterTable.item_entindex_const)
    local hero = EntIndexToHScript(filterTable.inventory_parent_entindex_const)
    local itemName = item:GetAbilityName()
    if itemName == "item_lia_knight_shield" or itemName == "item_lia_knight_cuirass" then
        if hero:HasItemInInventory("item_lia_knight_shield",false) or hero:HasItemInInventory("item_lia_knight_cuirass",false) then
            for i=6,9 do
                if hero:GetItemInSlot(i) == nil then 
                    filterTable.suggested_slot = i
                    SendErrorMessage(hero:GetPlayerID(), "#lia_hud_error_cant_have_two_items_retdmg")
                    return true
                end
            end
        end
    end

    return true
end

function Survival:GoldFilter(filterTable)
    --PrintTable("GoldFilter",filterTable)
    if filterTable.reason_const == DOTA_ModifyGold_HeroKill or filterTable.reason_const == DOTA_ModifyGold_SharedGold or filterTable.reason_const == DOTA_ModifyGold_SelectionPenalty or filterTable.reason_const == DOTA_ModifyGold_Death then 
        return false 
    end
    return true
end

function Survival:ExperienceFilter(filterTable)
    --PrintTable("ExperienceFilter",filterTable)
    if Survival.State == SURVIVAL_STATE_DUEL_TIME then --на дуэлях опыта не даем
        return false
    end

    if filterTable.reason_const == DOTA_ModifyXP_CreepKill then
        return false
    end

    --[[local expMultiplier = self.flExpFix[Survival:GetHeroCount(false)] -- коррекция получаемого опыта в зависимости от кол-ва героев в игре
    
    if self.IsExtreme then --множители опыта для экстрима или лайта
        expMultiplier = expMultiplier + self.flExtremeExpMultiplier
    elseif self.IsLight then
        expMultiplier = expMultiplier + self.flLightExpMultiplier
    end

    filterTable.experience = filterTable.experience * expMultiplier]]
    print(filterTable.experience)
    return true

end

function Survival:onThink()

	--
	-- update for fallen count get damage
	local ndata
    for i = 1, #self.tHeroes do
        hero = self.tHeroes[i]
		if hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
			if hero.accumDamage then
				ndata = {count = hero.accumDamage}
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
        FindClearSpaceForUnit_IgnoreNeverMove(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerID(),hero.abs)
    end)
end

function Survival:_GiveRoundBounty()
    local heroCount = Survival:GetHeroCount(false)
    goldBounty = self.nWaveSpawnCount[heroCount] / heroCount * self.nGoldPerWave[self.nRoundNum]
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
        goldBounty = goldBounty + (self.nEqualGoldPool / heroCount)
    end


    goldBounty = goldBounty + 30 --компенсация за отключенные тики золота

    -- Золото за быстрое прохождение
    local roundDuration = GameRules:GetDOTATime(false,false) - self.flRoundStartTime - 1

    local roundDurationMessage = roundDuration --для дебага
    
    if self.nRoundNum % 5 == 0 then
        roundDuration = roundDuration - self.nfastBossTime
    else
        roundDuration = roundDuration - self.nfastWaveTime
    end

    if roundDuration < 0 then
        roundDuration = 0
    end

    local fastRoundGoldBonus = self.nfastRoundGold - roundDuration

    if fastRoundGoldBonus < 0 then
        fastRoundGoldBonus = 0
    end

    print("_GiveRoundBounty:","Round duration:  "..roundDurationMessage,"Gold bonus: "..fastRoundGoldBonus,".")
    goldBounty = goldBounty + fastRoundGoldBonus
    --

    DoWithAllHeroes(function(hero)
        local oldGold = hero:GetGold()
        hero:ModifyGold(goldBounty, false, DOTA_ModifyGold_Unspecified)
        PlayerResource:ModifyLumber(hero:GetPlayerOwnerID(),lumberBounty)
        print(hero:GetUnitName(),"gold",oldGold," --> ",tostring(hero:GetGold()))
    end)
end

function Survival:EndRound()
    print("Survival:EndRound",self.nRoundNum)
    self.nDeathCreeps = 0
    self.nCreepsSpawned = 0

    TimeLine:RoundEnd()

    Timers:RemoveTimer("lateWaveDebuffs")
    DoWithAllHeroes(function(hero)
        hero:RemoveModifierByName("modifier_"..self.nRoundNum.."_wave_debuff")
        
        local modifierSpellBlock = hero:FindModifierByName("modifier_item_sphere_target")
        if modifierSpellBlock and modifierSpellBlock:GetAbility():GetAbilityName() == "item_lia_rune_of_protection" then
            modifierSpellBlock:Destroy()
        end
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
        
        Survival:_GiveRoundBounty()

        FightRecap:UpdateClientInfo(Survival.State == SURVIVAL_STATE_ROUND_MEGABOSS)

        if self.nRoundNum % 3 == 0 and not self.IsDuelOccured and self:GetHeroCount(false) > 1 then
            Survival:StartDuels()
        else

            --Survival:_GiveRoundBounty()
            Survival:PrepareNextRound()
        end
    end)
end


function Survival:PrepareNextRound()
    self.nRoundNum = self.nRoundNum + 1

    local timeBeforeNextRound = self.nPreRoundTime
    if self.nRoundNum == 20 then
        timeBeforeNextRound = self.nPreFinalTime
    end

    self.flRoundStartTime = GameRules:GetDOTATime(false,false) + timeBeforeNextRound
    
    print("Next round - ", self.nRoundNum)

    nPlayersReady = 0
    LiA.bForceRoundEnabled = true
    CustomGameEventManager:Send_ServerToAllClients("round_force_enabled", {enabled = true})

    self.IsDuelOccured = false
    Survival.State = SURVIVAL_STATE_PRE_ROUND_TIME

    StartTimer(timeBeforeNextRound,1,self.nRoundNum)
    --print(GameRules:GetDOTATime(false,false))

    Timers:CreateTimer("StartRoundTimer",
        {
            endTime = timeBeforeNextRound-3, 
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
        if hero:GetPlayerOwner() == nil then
            self:HideHero(hero)
        elseif hero.hidden then
            self:UnhideHero(hero)
        end
    end
end

--------------------------------------------------------------------------------------------------

function Survival:_TeleportHeroesToBossArena()
    local length = 70 * Survival:GetHeroCount(false)
    DoWithAllHeroes(function(hero)
        hero.abs = hero:GetAbsOrigin() 
        hero:Stop()
        hero:SetForwardVector(Vector(0, 1, 0))
        FindClearSpaceForUnit_IgnoreNeverMove(hero, ARENA_TELEPORT_COORD_BOT + Vector(RandomInt(-length,length),RandomInt(-50,50),0), false)

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
    print("Spawn wave", self.nRoundNum, "for", self:GetHeroCount(false), "heroes")
	--AIcreeps
    Survival:AICreepsDefault()
    Survival.State = SURVIVAL_STATE_ROUND_WAVE
    
    self.nHeroCountCreepsSpawned = self:GetHeroCount(false) --чтобы уберечь от багов при изменении кол-ва героев во время волны(кто-то взял героя после старта волны например)
    
    local unit1, unit2, boss1, boss2
    local creepName = tostring(self.nRoundNum).."_wave_creep"
    local bossName = tostring(self.nRoundNum).."_wave_boss"
    if self.IsExtreme then 
        creepName = creepName.."_extreme"
        bossName = bossName.."_extreme"
    end
    
    local pathEffect = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
    


    local spawnCount = 0
    
    local all_time = 2.0
    local tick = all_time/self.nWaveSpawnCount[self.nHeroCountCreepsSpawned]

    Timers:CreateTimer(RandomFloat(tick*2,all_time),
        function()
            boss1 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_LEFT + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            boss2 = CreateUnitByName(bossName, WAVE_SPAWN_COORD_TOP  + RandomVector(RandomInt(-500, 500)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss1)
            ParticleManager:CreateParticle(pathEffect, PATTACH_ABSORIGIN, boss2)
            boss1:EmitSound("DOTA_Item.BlinkDagger.Activate")
            boss2:EmitSound("DOTA_Item.BlinkDagger.Activate")

            --[[boss1.deathXP = boss1:GetDeathXP()
            boss1:SetDeathXP(0)

            boss2.deathXP = boss2:GetDeathXP()
            boss2:SetDeathXP(0)]]
            
            Survival:AICreepsInsertToTable(boss1,boss2)
            self.nCreepsSpawned = self.nCreepsSpawned + 2
            
            if self.IsEqualGold then
                self.nEqualGoldPool = self.nEqualGoldPool + boss1:GetGoldBounty()*2
                boss1:SetMinimumGoldBounty(0)
                boss2:SetMinimumGoldBounty(0)
                boss1:SetMaximumGoldBounty(0)
                boss2:SetMaximumGoldBounty(0)
            end
        end
    )
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
            --[[unit1.deathXP = unit1:GetDeathXP()
            unit1:SetDeathXP(0)

            unit2.deathXP = unit2:GetDeathXP()
            unit2:SetDeathXP(0)]]


            Survival:AICreepsInsertToTable(unit1,unit2)
            self.nCreepsSpawned = self.nCreepsSpawned + 2
            
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
    if self:GetHeroCount(true) == 0 then 
        GameRules:SetCustomVictoryMessage("#lose_message")
        Survival:EndGame(DOTA_TEAM_BADGUYS)
        return   
    end

    FightRecap:Init()

    self.hHealer:Disable()

    
    LiA.bForceRoundEnabled = false
    CustomGameEventManager:Send_ServerToAllClients("round_force_enabled", {enabled = false})
    
    CustomGameEventManager:Send_ServerToAllClients( "round_start", {round_number = self.nRoundNum} )
    
    Timers:CreateTimer(3,function()
            DisableShop()
            PlayerResource:ClearReadyToRound()

            TimeLine:RoundStart()

            self.flRoundStartTime = GameRules:GetDOTATime(false,false)
            
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


function HeroToPedestal(hero,place)
    if not hero then
        return 
    end

    local vecOrigin = Entities:FindByName(nil, tostring(place).."_place"):GetAbsOrigin()
    local forward = { 
        Vector(2,-1,0), 
        Vector(5,-1,0), 
        Vector(1,-1,0) 
    }

    if not hero:IsAlive() then
        hero:RespawnHero(false,false)
    end

    hero:Purge(true, true, false, true, true)

    hero:RemoveModifierByName("modifier_item_sphere_target")
    
    local fire_gloves = GetItemInInventory(hero,"item_lia_fire_gloves") or GetItemInInventory(hero,"item_lia_fire_gloves_2")
    if fire_gloves and fire_gloves:GetToggleState() then 
        fire_gloves:ToggleAbility()
    end 

    hero:SetAbsOrigin(vecOrigin)
    hero:SetForwardVector(forward[place])
    hero:Interrupt()
    hero:StartGesture(ACT_DOTA_IDLE)
    hero:StartGesture(ACT_DOTA_VICTORY)
    --DebugDrawLine(self.tHeroes[2]:GetAbsOrigin(), self.tHeroes[2]:GetAbsOrigin()+self.tHeroes[2]:GetForwardVector()*100, 100, 100, 100, true, 100)
end

function Survival:EndGame(teamWin)
    local GameMode = GameRules:GetGameModeEntity()
    --local data = LiA:GetDataForSend()
    self.tHeroes[1]:AddNewModifier(self.tHeroes[1],nil,"modifier_test_lia",nil) 
    Timers:CreateTimer(1,function()
        if teamWin == DOTA_TEAM_GOODGUYS then
            local vecFirstPlace = Entities:FindByName(nil, "1_place"):GetAbsOrigin()
            local vecCamera = vecFirstPlace-Vector(-470,370,0)

            ChangeWorldBounds(vecCamera,vecCamera)
            SetCameraToPosForPlayer(-1,vecCamera)

            self.tHeroes[1]:AddNewModifier(self.tHeroes[1],nil,"modifier_test_lia",nil)
            
            HeroToPedestal(PlayerResource:GetSelectedHeroEntity( PlayerResource:GetPlayerIdAtPlace(1) ), 1)
            HeroToPedestal(PlayerResource:GetSelectedHeroEntity( PlayerResource:GetPlayerIdAtPlace(2) ), 2)
            HeroToPedestal(PlayerResource:GetSelectedHeroEntity( PlayerResource:GetPlayerIdAtPlace(3) ), 3)
        end
        TimeLine:GameEnd()
        GameRules:SetGameWinner(teamWin)
        Stats.MatchResult(teamWin == DOTA_TEAM_GOODGUYS)
    end)
end

function Survival:ExperienceDistribute(killedUnit)
    local nHeroesAlive = Survival:GetHeroCount(true)
    
    local expMultiplier = self.flExpFix[Survival:GetHeroCount(false)] -- коррекция получаемого опыта в зависимости от кол-ва героев в игре
    
    if self.IsExtreme then --множители опыта для экстрима или лайта
        expMultiplier = expMultiplier + self.flExtremeExpMultiplier
    elseif self.IsLight then
        expMultiplier = expMultiplier + self.flLightExpMultiplier
    end

    if not killedUnit.deathXP then
        print("DeathXP not defined for "..killedUnit:GetUnitName())
        return
    end

    local xp = killedUnit.deathXP/nHeroesAlive * expMultiplier + RandomFloat(0,1)
    --print(xp)

    DoWithAllHeroes(function(hero)
        if hero:IsAlive() then
            hero:AddExperience(xp,DOTA_ModifyXP_Unspecified,false,true)
            --print(hero:GetCurrentXP())
        end
    end)

end

