function Survival:GetHeroToDuel()
    for i = 1, #self.tHeroes do
        if not self.tHeroes[i].IsDueled and IsValidEntity(self.tHeroes[i]) then
            self.tHeroes[i].IsDueled = true
            return self.tHeroes[i]
        end
    end
    return nil 
end

function Survival:StartDuels()
	timerPopup:Start(self.nPreDuelTime,"#lia_duel",0)
	Timers:CreateTimer(self.nPreDuelTime,
		function()
			self.DuelNumber = 0
			self.State = SURVIVAL_STATE_DUEL_TIME
			DisableShop()

			DoWithAllHeroes(function(hero)
            	hero:AddNewModifier(hero, nil, "modifier_stun_lua", {duration = -1})
        	end)

        	Survival:CheckDuel()
		end
	)
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
	hero1.abs = hero1:GetAbsOrigin()
    hero2.abs = hero2:GetAbsOrigin()
    hero1:Stop()
    hero2:Stop()
    hero1:SetForwardVector(Vector(0,1,0))
    hero2:SetForwardVector(Vector(0,-1,0))

    FindClearSpaceForUnit(hero1, ARENA_TELEPORT_COORD_BOT, false) 
    FindClearSpaceForUnit(hero2, ARENA_TELEPORT_COORD_TOP, false)

    hero2:SetTeam(DOTA_TEAM_BADGUYS)
    PlayerResource:UpdateTeamSlot(hero2:GetPlayerID(), DOTA_TEAM_BADGUYS,true)

    hero1:Heal(9999,hero1)
    hero2:Heal(9999,hero2)
    hero1:GiveMana(9999)
    hero2:GiveMana(9999)
    ResetAllAbilitiesCooldown(hero1)
    ResetAllAbilitiesCooldown(hero2)

    Timers:CreateTimer(0.5,
    	function()
    		SetCameraToPosForPlayer(-1,ARENA_CENTER_COORD)
    	end
    )


end