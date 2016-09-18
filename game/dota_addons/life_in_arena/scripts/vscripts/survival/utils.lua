function Survival:HideHero(hero)
	print("Hide hero", hero:GetName())

	hero.prorogueUnhide = false
	hero.prorogueHide = false

	if hero.hidden then 
		print("Already hidden")
		return 
	end
	
	if self.State >= SURVIVAL_STATE_ROUND_WAVE then
		if hero:IsAlive() then --отложим хайд героя, если сейчас идет раунд и герой жив
			hero.prorogueHide = true
			print("prorogueHide")
		end
	end

	if not hero.prorogueHide then
		print("hero hidden")
		hero:Interrupt()
		hero:AddNoDraw()
		hero:AddNewModifier(hero, nil, "modifier_hide_lua", nil)
		hero.abs = hero:GetAbsOrigin()
		hero:SetAbsOrigin(Vector(-3000,-3000,0))
		hero.hidden = 1
	end
end

function Survival:UnhideHero(hero)
	print("Unhide hero", hero:GetName())

	hero.prorogueUnhide = false
	hero.prorogueHide = false

	if not hero.hidden then 
		print("Not hidden")
		return 
	end

	if self.State >= SURVIVAL_STATE_ROUND_WAVE then --во время раунда не возвращаем героя
		print("prorogue unhide")
		hero.prorogueUnhide = true

		if self.State == SURVIVAL_STATE_ROUND_WAVE then 
			for _,unit in pairs(self.tHeroes) do 
				if unit:IsAlive() and not unit.hidden then 
					SetCameraToPosForPlayer(hero:GetPlayerID(),unit:GetAbsOrigin())
					break 
				end 
			end 
		else 
			SetCameraToPosForPlayer(hero:GetPlayerID(),ARENA_CENTER_COORD)
		end
	end

	if not hero.prorogueUnhide then
		print("hero unhidden")
		if not hero:IsAlive() then
			hero:RespawnHero(false, false, false)
		end
		hero:RemoveModifierByName("modifier_hide_lua")
		FindClearSpaceForUnit(hero, hero.abs, false)
		ResolveNPCPositions(hero.abs, 64)
		hero:RemoveNoDraw()
		hero.hidden = nil

		SetCameraToPosForPlayer(hero:GetPlayerID(),hero.abs)

	end
end

function Survival:GetHeroCount(bOnlyAlive)
	local count = 0
	for _,hero in pairs(self.tHeroes) do
		if not hero.hidden and (not bOnlyAlive or hero:IsAlive() or hero:IsReincarnating()) then  
			count = count + 1
		end
	end
	return count
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

function ChangeWorldBounds(vMax,vMin)
	local oldBounds = Entities:FindByClassname(nil, "world_bounds")
	if oldBounds then 
		oldBounds:RemoveSelf()
	end

	SpawnEntityFromTableSynchronous("world_bounds", {Max = vMax, Min = vMin})
end

function ClearBossArenaByItems()
    local containers = Entities:FindAllByClassnameWithin("dota_item_drop", ARENA_CENTER_COORD, 1000)
    for _,container in pairs(containers) do
        item = container:GetContainedItem()
        if item then
            if item:GetPurchaser() == nil then --руны
                container:RemoveSelf()
                item:RemoveSelf()
            else --остальные предметы
                container:SetAbsOrigin(Vector(0,1500,168)+RandomVector(RandomFloat(0, 200)))
            end
        end
    end
end

function SetNoCorpse( event )
    event.target.no_corpse = true
end

function FindCorpseInRadius( origin, radius )
    return Entities:FindByModelWithin(nil, CORPSE_MODEL, origin, radius) 
end

summon_units_nocorpse = { -- who cant res
	"android_clockwerk_goblin1",
	"android_clockwerk_goblin2",
	"android_clockwerk_goblin3",	
	--
	"phoenix_bm",	
	"phoenix_egg_bm",	
	--
	"firelord_lava_spawn1",	
	"firelord_lava_spawn2",	
	"firelord_lava_spawn3",
	--
	"npc_serpent_ward_1",	
	"npc_serpent_ward_2",	
	"npc_serpent_ward_3",	
	"npc_serpent_ward_4",	
	--
	"npc_water_elemental_1",	
	"npc_water_elemental_2",
	"npc_water_elemental_3",	
	"npc_water_elemental_4",	
	--
	"item_lia_healing_ward_unit",	
	--
	"keeper_of_the_grove_treant_1",	
	"keeper_of_the_grove_treant_2",
	"keeper_of_the_grove_treant_3",
	"keeper_of_the_grove_young_treant",
	--
	"necromancer_skeleton1",
	"necromancer_skeleton2",
	"necromancer_skeleton3",
	"necromancer_skeleton4",
	--
	"book_of_the_dead_skeleton_melee",
	"book_of_the_dead_skeleton_melee_ranged",
	--
	"npc_lia_boar",
	--
	"spherical_staff_fire_golem",
	--
	"spirit_of_the_plains1",
	"spirit_of_the_plains2",
	"spirit_of_the_plains3",
	--
	"ghost_1",
	"ghost_2",
	"ghost_3",
	"ghost_4",
	--
	"fire_golem_10_wave",

	"shadow_master_shadow",
	"hell_beast",
}

function UnitIsSummonNoCorpse(u)
	local unitName = u:GetUnitName()
	for _,v in pairs(summon_units_nocorpse) do
		if unitName == v then
			return true
		end
	end
	return false
end

summon_units = {
	"android_clockwerk_goblin1",
	"android_clockwerk_goblin2",
	"android_clockwerk_goblin3",	
	--
	"white_wolf_bm",	
	"jungle_stalker_bm",	
	"phoenix_bm",	
	"phoenix_egg_bm",	
	"bear_bm",	
	--
	"butcher_zombie_1",
	"butcher_zombie_2",
	"butcher_zombie_3",	
	--
	"firelord_lava_spawn1",
	"firelord_lava_spawn2",
	"firelord_lava_spawn3",
	--
	"npc_serpent_ward_1",	
	"npc_serpent_ward_2",
	"npc_serpent_ward_3",
	"npc_serpent_ward_4",
	--
	"npc_water_elemental_1",
	"npc_water_elemental_2",
	"npc_water_elemental_3",
	"npc_water_elemental_4",
	--
	"item_lia_healing_ward_unit",
	--
	"keeper_of_the_grove_treant_1",
	"keeper_of_the_grove_treant_2",
	"keeper_of_the_grove_treant_3",
	"keeper_of_the_grove_young_treant",
	--
	"necromancer_skeleton1",	
	"necromancer_skeleton2",
	"necromancer_skeleton3",
	"necromancer_skeleton4",
	--
	"book_of_the_dead_skeleton_melee",
	"book_of_the_dead_skeleton_melee_ranged",
	"npc_lia_troll_defender",
	"npc_lia_troll_healer",
	"npc_doom_guard_spawn",
	"npc_lia_boar",
	--
	"hell_beast",
	--
	"queen_of_spiders_spider_1",
	"queen_of_spiders_spider_2",
	"queen_of_spiders_spider_3",
	--
	"spherical_staff_fire_golem",
	--
	"spirit_of_the_plains1",
	"spirit_of_the_plains2",
	"spirit_of_the_plains3",
	"ghost_1",
	"ghost_2",
	"ghost_3",
	"ghost_4",
	--
	"fire_golem_10_wave",

	"shadow_master_shadow",
}

function UnitIsSummon(u)
	local unitName = u:GetUnitName()
	for _,v in pairs(summon_units) do
		if unitName == v then
			return true
		end
	end
	return false
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