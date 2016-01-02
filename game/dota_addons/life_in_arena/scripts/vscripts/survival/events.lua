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
    PlayerResource:UpdateTeamSlot(playerID, DOTA_TEAM_GOODGUYS, 1)
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
    local attacker
    local attackerHero
    if keys.entindex_attacker then 
        attacker = EntIndexToHScript(keys.entindex_attacker)
        attackerHero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID())
    end 
    
    local ownerHero = hero:GetPlayerOwner()
    if ownerHero then
        Timers:CreateTimer(0.1,function() ownerHero:SetKillCamUnit(nil) end) 
    end

    if hero:IsReincarnating() then 
        print("Will reincarnate")
        return
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
		--send to all players info about kill boss
		CustomGameEventManager:Send_ServerToAllClients( "upd_action_killboss", {pID = hero:GetPlayerID() } )
    end

    if self.State ~= SURVIVAL_STATE_ROUND_FINALBOSS then
	    self.nDeathCreeps = self.nDeathCreeps + 1
	    if self.nDeathCreeps == self.nWaveMaxCount[self.nHeroCountCreepsSpawned] then
	        Survival:EndRound()
	    end
	end
end

function Survival:OnEntityKilled(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)
    if keys.entindex_attacker then 
        local attacker = EntIndexToHScript(keys.entindex_attacker)
        local hero = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerOwnerID()) --находим героя игрока, владеющего юнитом
    end
    
    if killed:IsRealHero() then
        Survival:_OnHeroDeath(keys)
        return
    end

    if self.State == SURVIVAL_STATE_ROUND_FINALBOSS then
        Survival:_OnFinalBossDeath(keys)
    end

    if string.find(killed:GetUnitName(),"_wave_creep") and not killed:IsOwnedByAnyPlayer() then 
        Survival:_OnCreepDeath(keys)   
    elseif string.find(killed:GetUnitName(),"_boss") and not killed:IsOwnedByAnyPlayer() then
        Survival:_OnBossDeath(keys)
    elseif string.find(killed:GetUnitName(),"_wave_megaboss") and self.State ~= SURVIVAL_STATE_ROUND_FINALBOSS then
        Survival:EndRound()
    end 
	--
	if not string.find(killed:GetUnitName(),"_wave_megaboss") then
		-- If the unit is supposed to leave a corpse, create a dummy_unit to use abilities on it.
		Timers:CreateTimer(1, function() 
		if LeavesCorpse( killed ) then
				-- Create and set model
				local corpse = CreateUnitByName("dummy_unit", killed:GetAbsOrigin(), true, nil, nil, killed:GetTeamNumber())
				corpse:SetModel(CORPSE_MODEL)

				-- Set the corpse invisible until the dota corpse disappears
				corpse:AddNoDraw()
				
				-- Keep a reference to its name and expire time
				corpse.corpse_expiration = GameRules:GetGameTime() + CORPSE_DURATION
				corpse.unit_name = killed:GetUnitName()

				-- Set custom corpse visible
				Timers:CreateTimer(3, function() if IsValidEntity(corpse) then corpse:RemoveNoDraw() end end)

				-- Remove itself after the corpse duration
				Timers:CreateTimer(CORPSE_DURATION, function()
					if corpse and IsValidEntity(corpse) then
						corpse:RemoveSelf()
					end
				end)
			end
		end)
	end
	--

    Survival:AICreepsRemoveFromTable(killed)
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --self.nRoundNum = 15
        GameRules:SetPreGameTime(120)
        Survival:PrepareNextRound()
    end
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnConnectFull(event)
    local player = EntIndexToHScript(event.index+1)
    
    local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
    if hero then
        Survival:UnhideHero(hero) --in utils.lua
    end
end

function Survival:OnDisconnect(event)
    local player = LiA.vUserIds[event.userid]
    
    local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
    if hero then
        Survival:HideHero(hero) --in utils.lua
    end
end

---------------------------------------------------------------------------------------------------------------------------

function Survival:OnPlayerChat(event)
    --PrintTable("Survival:OnPlayerChat",event)
    local player = LiA.vUserIds[event.userid]

    if event.text == "+" then
        onPlayerReadyToWave(player) --LiA_ForceRound.lua
    end
    
	--[[
	if event.text == "kill" then
		local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        hero:ForceKill(true)
    end
	
	if event.text == "res" then
		local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
        hero:RespawnHero(false,false,false)
    end
	
    if event.text == "fade" then
        ParticleManager:CreateParticle("particles/black_screen.vpcf", PATTACH_WORLDORIGIN, player:GetAssignedHero())
    end
	
    if event.text == "lose" then
        Survival:EndGame(DOTA_TEAM_BADGUYS)
    end
	]]
	
end