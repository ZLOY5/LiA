function Survival:GetHeroToDuel()
    for i = 1, 8 do
        local playerId = PlayerResource:GetPlayerIdAtPlace(i)
        local hero = PlayerResource:GetSelectedHeroEntity(playerId)
        if hero and not hero.IsDueled and IsValidEntity(hero) and not hero.hidden then
            hero.IsDueled = true
            return hero
        end
    end
    return nil 
end

function Survival:StartDuels()
	print("Next round - duels")
    
    self.IsDuelOccured = true
    Survival.State = SURVIVAL_STATE_PRE_DUEL_TIME

    DoWithAllHeroes(function(hero)
        hero:ModifyGold(15, false, DOTA_ModifyGold_Unspecified) --компенсация за отключенные тики золота
    end)
     
    --timerPopup:Start(self.nPreDuelTime,"#lia_duel",0)
    StartTimer(self.nPreDuelTime,"#TimerPreDuel",0)
	Timers:CreateTimer(self.nPreDuelTime,
		function()
			self.DuelNumber = 0
			self.State = SURVIVAL_STATE_DUEL_TIME
			DisableShop()
            
			DoWithAllHeroes(function(hero)
                hero:Purge(true, true, false, true, false)
            	hero:AddNewModifier(hero, nil, "modifier_stun_lua", {duration = -1})
                hero.abs = hero:GetAbsOrigin()
        	end)

            ClearBossArenaByItems()
        	Survival:CheckDuel()
		end
	)

    for _,hero in pairs(self.tHeroes) do
        if hero.prorogueHide then 
            self:HideHero(hero)
        elseif hero.prorogueUnhide then
            self:UnhideHero(hero)
        end
    end
end

function Survival:CheckDuel()
	hero1 = Survival:GetHeroToDuel()
	hero2 = Survival:GetHeroToDuel()

	if hero1 and hero2 then
		self.DuelFirstHero = hero1
		self.DuelSecondHero = hero2
		self.DuelNumber = self.DuelNumber + 1
		Survival:Duel(hero1,hero2)
	else 
		Survival:EndDuels()
	end
end

function Survival:Duel(hero1,hero2)
    ParticleManager:CreateParticle("particles/black_screen.vpcf", PATTACH_WORLDORIGIN, hero1)
	 Timers:CreateTimer(0.5,
    	function()
            hero1:Interrupt()
            hero2:Interrupt()
            hero1:SetForwardVector(Vector(0,1,0))
            hero2:SetForwardVector(Vector(0,-1,0))

            FindClearSpaceForUnit(hero1, ARENA_TELEPORT_COORD_BOT, false) 
            FindClearSpaceForUnit(hero2, ARENA_TELEPORT_COORD_TOP, false)

            local modifierSpellBlock = hero1:FindModifierByName("modifier_item_sphere_target")
            if modifierSpellBlock and modifierSpellBlock:GetAbility():GetAbilityName() == "item_lia_rune_of_protection" then
                modifierSpellBlock:Destroy()
            end

            local modifierSpellBlock = hero2:FindModifierByName("modifier_item_sphere_target")
            if modifierSpellBlock and modifierSpellBlock:GetAbility():GetAbilityName() == "item_lia_rune_of_protection" then
                modifierSpellBlock:Destroy()
            end

            hero1:Heal(9999,hero1)
            hero2:Heal(9999,hero2)
            hero1:GiveMana(9999)
            hero2:GiveMana(9999)
            ResetAllAbilitiesCooldown(hero1)
            ResetAllAbilitiesCooldown(hero2)
            hero1:AddNewModifier(hero1,nil,"modifier_invisible",{duration = 0.5})
            local gold = hero2:GetGold()
            hero2:SetTeam(DOTA_TEAM_BADGUYS)
            if hero2:GetPlayerOwner() then
                hero2:GetPlayerOwner():SetTeam(DOTA_TEAM_BADGUYS)
            end
            hero2:AddNewModifier(hero2,nil,"modifier_invisible",{duration = 0.5})
            PlayerResource:UpdateTeamSlot(hero2:GetPlayerID(), DOTA_TEAM_BADGUYS, 1)
            hero2:SetGold(gold, false)

            ChangeWorldBounds(WORLD_BOUNDS_BOSS_MAX,WORLD_BOUNDS_BOSS_MIN)

    		SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD+Vector(0,-100,0))

            local msg = { 
                            duel_number = self.DuelNumber,
                            hero1 = hero1:GetClassname(),
                            hero2 = hero2:GetClassname() 
                        }
            CustomGameEventManager:Send_ServerToAllClients( "duel_start", msg )
    	end
    )

    local counter = 6
    Timers:CreateTimer(1,
        function()
            CleanUnitsOnMap()
            
            if counter == 0 then
                hero1:RemoveModifierByName("modifier_stun_lua")
                hero2:RemoveModifierByName("modifier_stun_lua")
                --timerPopup:Start(120,"#lia_expire_duel",0)
                StartTimer(120,"TimerDuel",0)
                Timers:CreateTimer("duelExpireTime",{ --таймер дуэли
                    useGameTime = true,
                    endTime = 120,
                    callback = function()
                        Survival:EndDuel(nil,nil)
                        return nil
                    end})
                return nil
            else
                counter = counter - 1
                ShowCenterMessage(tostring(counter),1)
                return 1
            end
        end
    )

end

function Survival:DuelRegisterHeroDeath(attacker,killed)

    if not self.DuelOneHeroKilled then
        self.DuelOneHeroKilled = 1
        Timers:CreateTimer(1,function()
            if not killed:IsAlive() and not attacker:IsAlive() then 
                Survival:EndDuel(nil,nil)
            else
                Survival:EndDuel(attacker,killed)
            end
            self.DuelOneHeroKilled = nil
        end)
    end
end

function Survival:EndDuel(winner,loser)
    local hero1 = self.DuelFirstHero
    local hero2 = self.DuelSecondHero

    self.DuelFirstHero = nil
    self.DuelSecondHero = nil

    CleanUnitsOnMap()
    
    if winner and loser then --проверка на отсутствие ничьей
        if winner == loser then -- проверяем самоубился ли герой
            if loser == hero2 then -- устанавливаем другого героя победителем
                winner = hero1
            else
                winner = hero2
            end
        end
        print("Winner",winner:GetUnitName(),winner)
        print("Loser",loser:GetUnitName(),loser)
    end

    hero2:SetTeam(DOTA_TEAM_GOODGUYS)
    if hero2:GetPlayerOwner() then
        hero2:GetPlayerOwner():SetTeam(DOTA_TEAM_GOODGUYS)
    end
    PlayerResource:UpdateTeamSlot(hero2:GetPlayerID(), DOTA_TEAM_GOODGUYS, 1) 

    if winner ~= nil then 
        winner:ModifyGold(200, false, DOTA_ModifyGold_Unspecified) 
        PlayerResource:ModifyLumber(winner:GetPlayerOwnerID(),8)
    else --ничья
        --GameRules:SendCustomMessage("#lia_duel_expiretime", DOTA_TEAM_GOODGUYS, 0)
        hero1:ModifyGold(100, false, DOTA_ModifyGold_Unspecified) 
        PlayerResource:ModifyLumber(hero1:GetPlayerOwnerID(),4)

        hero2:ModifyGold(100, false, DOTA_ModifyGold_Unspecified) 
        PlayerResource:ModifyLumber(hero2:GetPlayerOwnerID(),4)
    end

    StopTimer()
    Timers:RemoveTimer("duelExpireTime")

    if hero1:IsAlive() then
        hero1:Purge(true, true, false, true, false)
        hero1:AddNewModifier(hero1, nil, "modifier_stun_lua", {duration = -1})
        hero1:Heal(9999,hero1)
        hero1:GiveMana(9999) 
        local fire_gloves = GetItemInInventory(hero1,"item_lia_fire_gloves") or GetItemInInventory(hero1,"item_lia_fire_gloves_2")
        if fire_gloves and fire_gloves:GetToggleState() then 
            fire_gloves:ToggleAbility()
        end  
    end

    if hero2:IsAlive() then
        hero2:Purge(true, true, false, true, false)
        hero2:AddNewModifier(hero2, nil, "modifier_stun_lua", {duration = -1})
        hero2:Heal(9999,hero2)
        hero2:GiveMana(9999) 
        local fire_gloves = GetItemInInventory(hero2,"item_lia_fire_gloves") or GetItemInInventory(hero2,"item_lia_fire_gloves_2")
        if fire_gloves and fire_gloves:GetToggleState() then 
            fire_gloves:ToggleAbility()
        end 
    end
    Timers:CreateTimer(2,function()
        ClearBossArenaByItems()
        CleanUnitsOnMap()

        if not hero1:IsAlive() then
            hero1:RespawnHero(false, false, false)
            hero1:AddNewModifier(hero1, nil, "modifier_stun_lua", nil)
        end

        if not hero2:IsAlive() then
            hero2:RespawnHero(false, false, false)
            hero2:AddNewModifier(hero2, nil, "modifier_stun_lua", nil)
        end
    
        FindClearSpaceForUnit(hero1, hero1.abs, false) 
        FindClearSpaceForUnit(hero2, hero2.abs, false) 

        Survival:CheckDuel()
    end)  
    
end

function Survival:EndDuels()

    for i = 1, #self.tHeroes do
        self.tHeroes[i].IsDueled = false
    end

    RespawnAllHeroes()

    ChangeWorldBounds(WORLD_BOUNDS_MAX,WORLD_BOUNDS_MIN)

    DoWithAllHeroes(function(hero)
        ResetAllAbilitiesCooldown(hero)
        hero:RemoveModifierByName("modifier_stun_lua")
        FindClearSpaceForUnit(hero, hero.abs, false)
        SetCameraToPosForPlayer(hero:GetPlayerID(),hero:GetAbsOrigin())
        hero:Interrupt()
    end)

    EnableShop()

    Survival:_GiveRoundBounty()

    --self.nRoundNum = self.nRoundNum - 1
    Survival:PrepareNextRound()
end



