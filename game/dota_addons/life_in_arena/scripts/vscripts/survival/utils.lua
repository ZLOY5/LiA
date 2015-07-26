function Survival:HideHero(hero)
	local prorogueHide = false

	for k,v in pairs(self.tProrogueUnhide) do --отменяем отложенный анхайд
		if v == hero then
			table.remove(self.tProrogueUnhide,k)
		end
	end
	
	if self.State >= SURVIVAL_STATE_ROUND_WAVE then
		if hero:IsAlive() then --отложим хайд героя, если сейчас идет раунд и герой жив
			prorogueHide = true
		end
	end

	if prorogueHide then
		table.insert(self.tProrogueHide,hero)
	else
		hero:Interrupt()
		hero:AddNoDraw()
		hero:AddNewModifier(hero, nil, "modifier_hide_lua", nil)
		hero.abs = hero:GetAbsOrigin()
		hero:SetAbsOrigin(Vector(0,0,0))
		hero.hidden = 1

		self.nHeroCount = self.nHeroCount - 1
		if not hero:IsAlive() and self.State >= SURVIVAL_STATE_ROUND_WAVE then
			self.nDeathHeroes = self.nDeathHeroes - 1
		end
	end
end

function Survival:UnhideHero(hero)
	local prorogueUnhide = false

	for k,v in pairs(self.tProrogueHide) do --если герой должен был быть спрятан позже, то отменяем это
		if v == hero then
			table.remove(self.tProrogueHide,k)
		end
	end
	
	if self.State >= SURVIVAL_STATE_ROUND_WAVE then --во время раунда не возвращаем героя
		prorogueUnhide = true
	end

	if prorogueUnhide then
		table.insert(self.tProrogueUnhide,hero)
	else
		hero:RemoveModifierByName("modifier_hide_lua")
		hero:SetAbsOrigin(hero.abs)
		hero:RemoveNoDraw()
		hero.hidden = nil

		self.nHeroCount = self.nHeroCount + 1
	end
end

function RespawnAllHeroes() 
	DoWithAllHeroes(function(hero)
		if not hero:IsAlive() then
			hero:RespawnHero(false,false,false)
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
		end
	end)
end

function DoWithAllHeroes(whatDo)
	if type(whatDo) ~= "function" then
		print("DoWithAllHeroes:not func")
		return
	end
	for i = 1, #Survival.tHeroes do
		if not Survival.tHeroes[i].hidden then
			whatDo(Survival.tHeroes[i])
		end
	end
end