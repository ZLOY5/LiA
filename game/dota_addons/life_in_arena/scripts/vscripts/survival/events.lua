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

    self.nDeathCreeps = self.nDeathCreeps + 1
    if self.nDeathCreeps == self.nWaveMaxCount[self.nHeroCountCreepsSpawned] then
        Survival:EndRound()
    end
end




function SetNoCorpse( event )
    event.target.no_corpse = true
end

function FindCorpseInRadius( origin, radius )
    return Entities:FindByModelWithin(nil, CORPSE_MODEL, origin, radius) 
end

-- who cant res
function UnitIsSummonNoCorpse(u)
	if u:GetUnitName() == "android_clockwerk_goblin1" then
		return true
	elseif u:GetUnitName() == "android_clockwerk_goblin2" then
		return true
	elseif u:GetUnitName() == "android_clockwerk_goblin3" then
		return true
	--
	elseif u:GetUnitName() == "phoenix_bm"    then
		return true
	elseif u:GetUnitName() == "phoenix_egg_bm"    then
		return true
	--
	elseif u:GetUnitName() == "firelord_lava_spawn1"  then
		return true
	elseif u:GetUnitName() == "firelord_lava_spawn2"  then
		return true
	elseif u:GetUnitName() == "firelord_lava_spawn3"  then
		return true
	--
	elseif u:GetUnitName() == "npc_serpent_ward_1" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_2" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_3" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_4" then
		return true
	--
	elseif u:GetUnitName() == "npc_water_elemental_1" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_2" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_3" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_4" then
		return true
	--
	elseif u:GetUnitName() == "item_lia_healing_ward_unit" then
		return true
	--
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_1" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_2" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_3" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_young_treant" then
		return true
	--
	elseif u:GetUnitName() == "necromancer_skeleton1" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton2" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton3" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton4" then
		return true
	--
	elseif u:GetUnitName() == "book_of_the_dead_skeleton_melee" then
		return true
	elseif u:GetUnitName() == "book_of_the_dead_skeleton_melee_ranged" then
		return true
	--
	elseif u:GetUnitName() == "npc_lia_boar" then
		return true
	--
	elseif u:GetUnitName() == "spherical_staff_fire_golem" then
		return true
	--
	elseif u:GetUnitName() == "spirit_of_the_plains1" then
		return true
	elseif u:GetUnitName() == "spirit_of_the_plains2" then
		return true
	elseif u:GetUnitName() == "spirit_of_the_plains3" then
		return true
	--
	elseif u:GetUnitName() == "ghost_1" then
		return true
	elseif u:GetUnitName() == "ghost_2" then
		return true
	elseif u:GetUnitName() == "ghost_3" then
		return true
	elseif u:GetUnitName() == "ghost_4" then
		return true
	--
	elseif u:GetUnitName() == "fire_golem_10_wave" then
		return true
		
	else
		--print("false")
		return false
	end
		
end


function UnitIsSummon(u)
	--print(u:GetUnitName())
	if u:GetUnitName() == "android_clockwerk_goblin1" then
		return true
	elseif u:GetUnitName() == "android_clockwerk_goblin2" then
		return true
	elseif u:GetUnitName() == "android_clockwerk_goblin3" then
		return true
	--
	elseif u:GetUnitName() == "white_wolf_bm"  then
		return true
	elseif u:GetUnitName() == "jungle_stalker_bm"   then
		return true
	elseif u:GetUnitName() == "phoenix_bm"    then
		return true
	elseif u:GetUnitName() == "phoenix_egg_bm"    then
		return true
	elseif u:GetUnitName() == "bear_bm"    then
		return true
	--
	elseif u:GetUnitName() == "butcher_zombie_1"  then
		return true
	elseif u:GetUnitName() == "butcher_zombie_2"  then
		return true
	elseif u:GetUnitName() == "butcher_zombie_3"  then
		return true
	--
	elseif u:GetUnitName() == "firelord_lava_spawn1"  then
		return true
	elseif u:GetUnitName() == "firelord_lava_spawn2"  then
		return true
	elseif u:GetUnitName() == "firelord_lava_spawn3"  then
		return true
	--
	elseif u:GetUnitName() == "npc_serpent_ward_1" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_2" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_3" then
		return true
	elseif u:GetUnitName() == "npc_serpent_ward_4" then
		return true
	--
	elseif u:GetUnitName() == "npc_water_elemental_1" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_2" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_3" then
		return true
	elseif u:GetUnitName() == "npc_water_elemental_4" then
		return true
	--
	elseif u:GetUnitName() == "item_lia_healing_ward_unit" then
		return true
	--
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_1" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_2" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_treant_3" then
		return true
	elseif u:GetUnitName() == "keeper_of_the_grove_young_treant" then
		return true
	--
	elseif u:GetUnitName() == "necromancer_skeleton1" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton2" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton3" then
		return true
	elseif u:GetUnitName() == "necromancer_skeleton4" then
		return true
	--
	elseif u:GetUnitName() == "book_of_the_dead_skeleton_melee" then
		return true
	elseif u:GetUnitName() == "book_of_the_dead_skeleton_melee_ranged" then
		return true
	elseif u:GetUnitName() == "npc_lia_troll_defender" then
		return true
	elseif u:GetUnitName() == "npc_lia_troll_healer" then
		return true
	elseif u:GetUnitName() == "npc_doom_guard_spawn" then
		return true
	elseif u:GetUnitName() == "npc_lia_boar" then
		return true
	--
	elseif u:GetUnitName() == "hell_beast" then
		return true
	--
	elseif u:GetUnitName() == "queen_of_spiders_spider_1" then
		return true
	elseif u:GetUnitName() == "queen_of_spiders_spider_2" then
		return true
	elseif u:GetUnitName() == "queen_of_spiders_spider_3" then
		return true
	--
	elseif u:GetUnitName() == "spherical_staff_fire_golem" then
		return true
	--
	elseif u:GetUnitName() == "spirit_of_the_plains1" then
		return true
	elseif u:GetUnitName() == "spirit_of_the_plains2" then
		return true
	elseif u:GetUnitName() == "spirit_of_the_plains3" then
		return true
	elseif u:GetUnitName() == "ghost_1" then
		return true
	elseif u:GetUnitName() == "ghost_2" then
		return true
	elseif u:GetUnitName() == "ghost_3" then
		return true
	elseif u:GetUnitName() == "ghost_4" then
		return true
	--
	elseif u:GetUnitName() == "fire_golem_10_wave" then
		return true
	--
	else
		--print("false")
		return false
	end
end

-- Custom Corpse Mechanic
function LeavesCorpse( unit )
    
    if not unit or not IsValidEntity(unit) then
        return false

    -- Heroes don't leave corpses (includes illusions)
    elseif unit:IsHero() then
        return false

    -- Ignore buildings 
    elseif string.find(unit:GetName(), "building") then
        return false

		
    -- Ignore summons
	--FindModifierByName
    --elseif unit:FindModifierByName('modifier_kill')  then -- ~= nil
	--elseif unit:IsSummoned() then
	--elseif UnitIsSummon(unit) then
	elseif UnitIsSummonNoCorpse(unit) then
		return false

    -- Ignore units that start with dummy keyword   
    elseif string.find(unit:GetUnitName(), "dummy") or string.find(unit:GetUnitName(), "megaboss") then
        return false

    -- Ignore units that were specifically set to leave no corpse
    elseif unit.no_corpse then
        return false

    -- Read the LeavesCorpse KV
    else
        local unit_info = GameRules.UnitKV[unit:GetUnitName()]
        if unit_info["LeavesCorpse"] and unit_info["LeavesCorpse"] == 0 then
            return false
        else
            -- Leave corpse     
            return true
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
    elseif self.State == SURVIVAL_STATE_ROUND_FINALBOSS then
        Survival:_OnFinalBossDeath(keys)
        return
    elseif string.find(killed:GetUnitName(),"_wave_creep") and not killed:IsOwnedByAnyPlayer() then 
        Survival:_OnCreepDeath(keys)   
    elseif string.find(killed:GetUnitName(),"_wave_boss") and not killed:IsOwnedByAnyPlayer() then
        Survival:_OnBossDeath(keys)
    elseif string.find(killed:GetUnitName(),"_wave_megaboss") then
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