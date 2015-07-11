
_G.LIA_MODE_SURVIVAL = 1
_G.LIA_MODE_BATTLE_OF_CLANS = 2

------------------------------------------------------------------------------

require('shop')
require('survival/survival')

------------------------------------------------------------------------------

LinkLuaModifier( "modifier_stun_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hide_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_orn_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_knight_shield_damage_return_lua", "items/modifier_knight_shield_damage_return_lua.lua", LUA_MODIFIER_MOTION_NONE) --модификатор для возвратки Рыцарского Щита
LinkLuaModifier( "modifier_knight_cuirass_damage_return_lua", "items/modifier_knight_cuirass_damage_return_lua.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier( "modifier_test_lia", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------------------

if LiA == nil then
	_G.LiA = class({})
end

------------------------------------------------------------------------------

MAX_LEVEL = 50

XP_TABLE = {}
XP_TABLE[1] = 0
for i = 2, MAX_LEVEL do
    XP_TABLE[i] = XP_TABLE[i-1] + i * 100 
end

------------------------------------------------------------------------------

function LiA:InitGameMode()

    self.vUserIds = {}
    self.tPlayers = {}
    self.GameMode = LIA_MODE_SURVIVAL

    GameRules:SetSafeToLeave(true)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetPreGameTime(0)
    GameRules:SetPostGameTime(30)
	GameRules:SetGoldTickTime(2)
	GameRules:SetGoldPerTick(1)
	GameRules:SetHeroMinimapIconScale(0.8)
    GameRules:SetCreepMinimapIconScale(0.8)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetCustomGameEndDelay(1)
    
	local GameMode = GameRules:GetGameModeEntity()
	
    GameMode:SetCustomHeroMaxLevel(MAX_LEVEL)    
    GameMode:SetCustomXPRequiredToReachNextLevel(XP_TABLE)
    GameMode:SetUseCustomHeroLevels(true)
    
    GameMode:SetRecommendedItemsDisabled(true)
    GameMode:SetHUDVisible(12, false)
    GameMode:SetHUDVisible(1, false) 
    GameMode:SetTopBarTeamValuesVisible(false)
    
    GameMode:SetBuybackEnabled(false)
    GameMode:SetTowerBackdoorProtectionEnabled(false)
    GameMode:SetStashPurchasingDisabled(true)
    GameMode:SetLoseGoldOnDeath(false)

    GameRules:LockCustomGameSetupTeamAssignment(true)
    GameRules:SetCustomGameSetupRemainingTime(5)
    GameRules:SetCustomGameSetupAutoLaunchDelay(5)
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 8 )

    --Convars:RegisterCommand( "lia_force_round", LiA:OnPlayerReadyToWave, "For force round", 0 )
      
    --listeners
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(LiA, 'OnGameStateChange'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(LiA, 'OnDisconnect'), self)
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(LiA, 'OnConnectFull'), self)
    
    --InitLogFile("log/LiA.txt","Init LiA")
end

function LiA:OnGameStateChange()  
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
        Survival:InitSurvival() --пока только так)
    end
    if self.GameMode == LIA_MODE_SURVIVAL then
        Survival:OnGameStateChange()
    else 

    end
end

function LiA:OnConnectFull(event)
    PrintTable("OnConnectFull",event)
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID = player:GetPlayerID()

    self.vUserIds[event.userid] = player
    
    --local playerSteamID = PlayerResource:GetSteamAccountID(playerID)
    --print("SteamID = ",playerSteamID)
    
    table.insert(self.tPlayers,player)
    nPlayers = nPlayers + 1  
end

function LiA:OnDisconnect(event)
    PrintTable("OnDisconnect",event)
    local player = self.vUserIds[event.userid]
    if player.readyToWave then
        player.readyToWave = false
        nPlayersReady = nPlayersReady - 1
    end
    for k,v in pairs(self.tPlayers) do 
        if player == v then
            table.remove(self.tPlayers,k)
        end
    end
    nPlayers = nPlayers - 1
end