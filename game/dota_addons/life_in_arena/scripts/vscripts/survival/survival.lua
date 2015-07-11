_G.SURVIVAL_STATE_PRE_GAME = 1
_G.SURVIVAL_STATE_PRE_ROUND_TIME = 1
_G.SURVIVAL_STATE_ROUND_WAVE = 2
_G.SURVIVAL_STATE_ROUND_MEGABOSS = 3
_G.SURVIVAL_STATE_ROUND_FINALBOSS = 4
_G.SURVIVAL_STATE_PRE_DUEL_TIME = 5
_G.SURVIVAL_STATE_DUEL_TIME = 6
_G.SURVIVAL_STATE_POST_GAME = 7


if Survival == nil then
	_G.Survival = class({})
end

function Survival:InitSurvival()

	self.tHeroes = {}
	self.nWaveNum = 0

    self.nHeroCount = 0
	self.nDeathHeroes = 0
	self.nDeathCreeps = 0
	self.nWaveSpawnCount = {20,26,32,38,44,50,56,62,68,74}   --крипов на спавн
	self.nWaveMaxCount = {42,54,66,78,90,102,114,126,138,150}

	self.nGoldPerWave = {0,12,12,12,12,12,15,15,18,18,18,18,21,24,24,27,27,30,30,30}

	self.nPreRoundTime = 60
	self.nPreDuelTime = 30

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

function LiA:ExperienceFilter(filterTable)
    if Survival:State == SURVIVAL_STATE_DUEL_TIME then
        return false
    end
    return true
end

function Survival:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        Survival:PrepareNextRound()
    end
end

function Survival:PrepareNextRound()
    self.nWaveNum = self.nWaveNum + 1

    if self.nWaveNum % 3 == 1 and not self.IsDuelOccured and self.nHeroCount > 1 then
        print("Next round - duels")
        Survival:State = SURVIVAL_STATE_PRE_DUEL_TIME

    else
        self.IsDuelOccured = false
        Survival:State = SURVIVAL_STATE_PRE_ROUND_TIME

        

        Timers:CreateTimer("StartRoundTimer",
            {
                endTime = self.nPreRoundTime-3, 
                callback = function() LiA:StartRound() end
            }
        )

        Timers:CreateTimer("preWaveTimer",{ endTime = PRE_WAVE_TIME, callback = function() LiA.SpawnWave() return nil end})

        PrecacheUnitByNameAsync(tostring(self.nWaveNum).."_wave_creep", function(...) end)
        PrecacheUnitByNameAsync(tostring(self.nWaveNum).."_wave_boss", function(...) end)
    end


end

function Survival:StartRound()
    if self.nWaveNum 
end