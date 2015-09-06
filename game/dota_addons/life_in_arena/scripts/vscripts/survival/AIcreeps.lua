
--[[

	USES
	in GameMode
	- tPlayers
	- tHeroes
	
	
	NEED put
	
	write FOR AIcreeps
	
+		in addon game mod
	require('AIcreeps')
	
	- GameMode:SetThink("onThinkAIcreepsUpdate", self)
+	(delete) GameMode:SetThink("onThinkAIcreepsAttack", self)
	(delete) GameMode:SetThink("onThinkAIspellcast", self)

	- in function LiA:SpawnWave()  
			in, after create units:
+				LiA:AICreepsInsertToTable({addUnit1 = unit1, addUnit2 = unit2})
		LiA:AICreepsInsertToTable({addUnit1 = boss1, addUnit2 = boss2})
		
	- IsWave = false
		function LiA:SpawnWave() 
+			IsWave = true
		function LiA:_EndWave()
			IsWave = false
		
		
	- function LiA:OnEntityKilled(keys)
		in two place:
		only creeps where
		nDeathCreeps = nDeathCreeps + 1
+		--
		LiA:AICreepsRemoveFromTable({removeUnit = ent})
		--
		
+		(delete) LiA:AICreepsInsertBosses({tBoss1 = boss1, tBoss2 = boss2})
	 

+		insert to files papka AI
		to 1_wave.lua and others in parametr "vscripts"
	 
	- 	"PathfindingSearchDepthScale"	"0.22"
		"AttackAcquisitionRange" "0" (for creeps, for bosses how need)
+		"VisionDaytimeRange" "800" 
		"VisionNighttimeRange" "800" 
		
+		delete from bosses KV cast (agressionRange = 0, so can not do it)
		
		
	 Also make:
		1. LiA.DeltaTime = 0.50

	
	
	HELP
		force disable system (not full, but minimum need)
		1. LiA_GameMode in comment --GameMode:SetThink("onThinkAIcreepsUpdate", self)
		2. npc_units "AttackAcquisitionRange" "0" replace "AttackAcquisitionRange" "10000" 
				now: 4 waves*2 type units = 8 positions
		3. in comment AICreepsAttackOneUnit({unit = thisEntity}) in files in papka AI
			and/or --"vscripts" in used units if can it do
				now: 1_wave_bosses.lua, 2_wave_bosses.lua, 3_wave_bosses.lua, 4_wave_bosses.lua
		4. if need --"PathfindingSearchDepthScale"	"0.22"
		. (not actual) uncomment spell cast bosses in normal_mode_bosses
		
		NOW its work for 1,2,3,4 wave
		12 wave 		--AICreepsAttackOneUnit({unit = thisEntity})
			(enable)
	 
	 
	 
]]


tCreeps1 = {} -- for creeps LEFT
tCreeps2 = {} -- for creeps TOP
--tBoss1 = nil -- for AI spell cast
--tBoss2 = nil
tHeroTarget = {} -- targets for tCreeps1 and tCreeps2
--tTargetParams = {{}} -- for find hero


function Survival:AICreepsDefault()
	tCreeps1 = {}
	tCreeps2 = {}
	tHeroTarget = {}
end



function Survival:AICreepsRemoveFromTable(removeUnit)
	for k,v in pairs(tCreeps1) do 
		if removeUnit == v then
			table.remove(tCreeps1,k)
		end
	end
	for k,v in pairs(tCreeps2) do 
		if removeUnit == v then
			table.remove(tCreeps2,k)
		end
	end
end


function Survival:AICreepsInsertToTable(unit1,unit2)
	table.insert(tCreeps1,unit1)
	table.insert(tCreeps2,unit2)
end

--function LiA:AICreepsInsertBosses(params)
--	tBoss1 = params.boss1
--	tBoss2 = params.boss2
--end

function Survival:onThinkAIcreepsUpdate()
	--IsWave = false
	if not GameRules:IsGamePaused() then
		if self.State == SURVIVAL_STATE_ROUND_WAVE then
			--local resFromFind = 
			--local tTargetBuf = resFromFind.tTargetBuf
			--local tTargetBufAbs = resFromFind.tTargetBufAbs
			local tTargetBuf = AICreepsAttackFindHeroes()
			--
			if #tCreeps1 > 0 then
				local randomUnit1 = tCreeps1[RandomInt(1,#tCreeps1)]
				AICreepsAttackUpdateTarget( {index = 1, targetCreep = randomUnit1, tTargetBuf = tTargetBuf} )
			end
			if #tCreeps2 > 0 then
				local randomUnit2 = tCreeps2[RandomInt(1,#tCreeps2)]
				AICreepsAttackUpdateTarget( {index = 2, targetCreep = randomUnit2, tTargetBuf = tTargetBuf} )
			end
			-- block units
			
			
			--
			--AICreepsAttackComand( {tTargetBuf=tTargetBuf,tTargetBufAbs=tTargetBufAbs} )
			--AICreepsAttackOld()
		end
	end
	--
	return 0.5
end


function Survival:onThinkAIcreepsAttack()
	--IsWave = false
	if not GameRules:IsGamePaused() then
		if self.State == SURVIVAL_STATE_ROUND_WAVE then
			--tTargetParams = AICreepsAttackFindHeroes()
			--local tTargetBuf = tTargetParams.tTargetBuf
			--local tTargetBufAbs = tTargetParams.tTargetBufAbs
			--
			-- MAIN METOD
			--Timers:CreateTimer(0.1,
			--function()
				--AICreepsAttackComand( {tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
				AICreepsAttackAllUnits()
			--end)
		end
	end
	--
	return 1.0
end


function AICreepsAttackOneUnit(params)
	--local tTargetBuf = params.tTargetBuf
	--local tTargetBufAbs = params.tTargetBufAbs
	--
	local unit = params.unit
	local index = AIcreepsGetIndex({creep = unit})		--params.index
	--local tCreeps = params.tCreeps
	--
	if not AICreepsCheck_tHeroTarget_isNotHave({index = index}) then
		--local randomUnit = tCreeps[RandomInt(1,#tCreeps)]
		--local absTarget = AICreepsAttackUpdateTarget( {index = index, targetCreep = randomUnit, tTargetBuf = tTargetBuf, tTargetBufAbs = --tTargetBufAbs} )
		local targetHe = tHeroTarget[index]
		--AICreepsAttackAllUnit( {index = index, target = targetHe, absTarget = targetHe:GetAbsOrigin()} )
		AICreepsAttackEachUnit( {absTarget = targetHe:GetAbsOrigin(),unit = unit, target = targetHe} )
	else
		if index == 1 then
			for i=1, #tCreeps1 do
				tCreeps1[i]:Hold()
			end
		else
			for i=1, #tCreeps2 do
				tCreeps2[i]:Hold()
			end
		end
	end
	
end


function AICreepsAttackAllUnits(params)
	--local tTargetBuf = params.tTargetBuf
	--local tTargetBufAbs = params.tTargetBufAbs
	--
	--local unit = params.unit
	--local index = AIcreepsGetIndex({creep = unit})		--params.index
	--local tCreeps = params.tCreeps
	--
	local targetHe
	local targetHeAbs
	if not AICreepsCheck_tHeroTarget_isNotHave({index = 1}) then
		--local randomUnit = tCreeps[RandomInt(1,#tCreeps)]
		--local absTarget = AICreepsAttackUpdateTarget( {index = index, targetCreep = randomUnit, tTargetBuf = tTargetBuf, tTargetBufAbs = --tTargetBufAbs} )
		targetHe = tHeroTarget[1]
		targetHeAbs = targetHe:GetAbsOrigin()
		--AICreepsAttackAllUnit( {index = index, target = targetHe, absTarget = targetHe:GetAbsOrigin()} )
		for i=1, #tCreeps1 do
			AICreepsAttackEachUnit( {absTarget = targetHeAbs, unit = tCreeps1[i], target = targetHe} )
		end
	else
		for i=1, #tCreeps1 do
			tCreeps1[i]:Hold()
		end
	end
	--
	if not AICreepsCheck_tHeroTarget_isNotHave({index = 2}) then
		--local randomUnit = tCreeps[RandomInt(1,#tCreeps)]
		--local absTarget = AICreepsAttackUpdateTarget( {index = index, targetCreep = randomUnit, tTargetBuf = tTargetBuf, tTargetBufAbs = --tTargetBufAbs} )
		targetHe = tHeroTarget[2]
		targetHeAbs = targetHe:GetAbsOrigin()
		--AICreepsAttackAllUnit( {index = index, target = targetHe, absTarget = targetHe:GetAbsOrigin()} )
		for i=1, #tCreeps2 do
			AICreepsAttackEachUnit( {absTarget = targetHeAbs, unit = tCreeps2[i], target = targetHe} )
		end
	else
		for i=1, #tCreeps2 do
			tCreeps2[i]:Hold()
		end
	end
	
end


function AIcreepsGetIndex(params)
	local creep = params.creep
	for i=1, #tCreeps1 do
		if tCreeps1[i] == creep then
			return 1
		end
	end
	return 2
end




function AICreepsCheck_tHeroTarget_isNotHave(params)
	local index = params.index
	if tHeroTarget[index] ~= nil then
		if not tHeroTarget[index]:IsAlive() or tHeroTarget[index].hidden then
			return true
		end
	else
		return true
	end
	return false
end

function AICreepsAttackUpdateTarget(params)
	local index = params.index
	--local tCreepsLoc = params.tCreepsLoc
	local targetCreep = params.targetCreep
	local absTarget
	local tTargetBuf = params.tTargetBuf
	--local tTargetBufAbs 
	--local flag = false

	if AICreepsCheck_tHeroTarget_isNotHave({index = index}) then
		--local randCreep = tCreepsLoc[RandomInt(1,#tCreepsLoc)]
		local absCreep = targetCreep:GetAbsOrigin()
		local minDist = 9999
		minInd = 1
		for h=1, #tTargetBuf do
			--if GridNav:CanFindPath( absCreep,tTargetBufAbs[h] ) then
				--local dist = GridNav:FindPathLength(absCreep,tTargetBufAbs[h])
				--tTargetBufAbs[h] = tTargetBuf[h]:GetAbsOrigin()
				local dist = MyFindPathLength({abs1 = absCreep, abs2 = tTargetBuf[h]:GetAbsOrigin()}) --tTargetBufAbs[h]
				if dist < minDist then
					minDist = dist
					minInd = h
				end
			--end
		end
		--heroTarget = tTargetBuf[minInd]
		tHeroTarget[index] = tTargetBuf[minInd]
		--absTarget = tTargetBufAbs[minInd]
	--else
		--absTarget = tHeroTarget[index]:GetAbsOrigin()
	end
	--return absTarget
end

function AICreepsAttackFindHeroes()
	local player
	local flag
	local tTargetBuf = {}
	--local tTargetBufAbs = {}
	
	-- run on all heroes and memory who need us

	for _,hero in pairs(Survival.tHeroes) do
		if hero and hero:IsAlive() and not hero.hidden then
			table.insert(tTargetBuf,hero)
			--table.insert(tTargetBufAbs,tHeroes[i]:GetAbsOrigin())
		end
	end
	--local res = {
	--	tTargetBuf = tTargetBuf,
	--	tTargetBufAbs = tTargetBufAbs
	--}
	--
	--return res
	return tTargetBuf
end




	-- NEED OPTIMIZE
	-- mb remove much getAbsOrigin
function IsBlockedF(params)
	local unit = params.unit
	local unitAbs = params.unitAbs
	local radiusUnit = unit:GetPaddedCollisionRadius()
	local tLen = {}
	--local tRadius = {}
	local tRadiusSort = {}
	--local table_near_allied_abs_sort_down = {}
	--local table_near_allied_abs_sort_up = {}
	--local table_near_allied_abs = {}
	local table_near_allied_abs_sort = {}
	--
	local table_near_allied_sort = {}
	local table_near_allied_sort_down = {}
	local table_near_allied_sort_up = {}
	local table_near_allied = FindUnitsInRadius(unit:GetTeam(),
									 unitAbs,
									 nil,
									 radiusUnit*2,
									 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									 DOTA_UNIT_TARGET_BASIC,
									 DOTA_UNIT_TARGET_FLAG_NONE,
									 FIND_ANY_ORDER,
									 false)
	local table_near_allied_extra = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,--unit:GetTeam(),
									 unitAbs,
									 nil,
									 radiusUnit*2,
									 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									 DOTA_UNIT_TARGET_BUILDING,
									 DOTA_UNIT_TARGET_FLAG_NONE,--DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									 FIND_ANY_ORDER,
									 false)
	-- remove from table self
	local ind
	for i=1, #table_near_allied do
		if table_near_allied[i] == unit then
			ind = i
			break
		end
	end
	table.remove(table_near_allied,ind)
	--
	--print("--= ")
	--print("#table_near_allied_extra = ",#table_near_allied_extra)
	--print("--= ")
	-- add extra units in main group
	for _,v in pairs(table_near_allied_extra) do 
		table.insert(table_near_allied, v)
	end
	-- if not units in table
	if #table_near_allied < 3 then
		return false
	end
	if #table_near_allied > 7 then
		return true
	end
	--
	-- get abs
	--for i=1, #table_near_allied do
	--	table.insert(table_near_allied_abs, table_near_allied[i]:GetAbsOrigin()  )
	--end
	-- 1 step
	local countLeft = 0
	local countRight = 0
	local AbsBufF
	for i=1, #table_near_allied do
		--razdelim na niz i verx
		AbsBufF = table_near_allied[i]:GetAbsOrigin()
		if unitAbs.y <= AbsBufF.y then
			table.insert(table_near_allied_sort_up, table_near_allied[i]  )
			--table.insert(table_near_allied_abs_sort_up, table_near_allied_abs[i]  )
		else
			table.insert(table_near_allied_sort_down, table_near_allied[i]  )
			--table.insert(table_near_allied_abs_sort_down, table_near_allied_abs[i]  )
		end
		--
		if unitAbs.x <= AbsBufF.x then
			countRight = countRight + 1
		else
			countLeft = countLeft + 1
		end
	end
	--
	--print("--= ")
	--print("##table_near_allied_sort_up = ",#table_near_allied_sort_up)
	--print("#table_near_allied_sort_down = ",#table_near_allied_sort_down)
	--print("--= ")
	--
	-- if all creeps in up or down offset by calc unit
	if #table_near_allied_sort_up == 0 or #table_near_allied_sort_down == 0 then
		return false
	end
	---- if all creeps in left or right offset by calc unit
	if countLeft == 0 or countRight == 0 then
		return false
	end
	--
	-- 2 step
	table.sort(table_near_allied_sort_up, function(a,b) return a:GetAbsOrigin().x > b:GetAbsOrigin().x end)
	table.sort(table_near_allied_sort_down, function(a,b) return a:GetAbsOrigin().x < b:GetAbsOrigin().x end)
	-- 3 step
	table_near_allied_sort = table_near_allied_sort_up
	for _,v in pairs(table_near_allied_sort_down) do 
		table.insert(table_near_allied_sort, v)
	end
	-- get abs
	--print("--= ")
	for i=1, #table_near_allied_sort do
		table.insert(table_near_allied_abs_sort, table_near_allied_sort[i]:GetAbsOrigin()  )
	--	print("table_near_allied_abs_sort[",i,"] = ",table_near_allied_abs_sort[i])
	end
	--print("--= ")

	--
	for i=1, #table_near_allied_sort do
		table.insert(tRadiusSort, table_near_allied_sort[i]:GetPaddedCollisionRadius()  )
	end
	--
	--
	local buf
	for i=1, #table_near_allied_sort-1 do
		buf = MyFindPathLength({abs1 = table_near_allied_abs_sort[i], abs2 = table_near_allied_abs_sort[i+1]})
		table.insert(tLen, buf - (tRadiusSort[i]+tRadiusSort[i+1]) )
		--GridNav:FindPathLength(table_near_allied_abs_sort[i],table_near_allied_abs_sort[i+1])
	end
	local co = #table_near_allied_abs_sort
	if co > 2 then
		buf = MyFindPathLength({abs1 = table_near_allied_abs_sort[1], abs2 = table_near_allied_abs_sort[co]})
		table.insert(tLen, buf - (tRadiusSort[1]+tRadiusSort[co]) )
		--GridNav:FindPathLength(table_near_allied_abs_sort[1],table_near_allied_abs_sort[co])
	end
	--
	--print("--= ")
	local flag = true
	for i=1, #tLen do
	--	print("tLen[",i,"] = ",tLen[i])
		if tLen[i] > radiusUnit*1.2 then
			flag = false
			break
		end
	end
	--print("--= ")
	return flag
end


function MyFindPathLength(params)
	local abs1 = params.abs1
	local abs2 = params.abs2
	return math.sqrt( (abs1.x-abs2.x)*(abs1.x-abs2.x) + (abs1.y-abs2.y)*(abs1.y-abs2.y) )
end


function AICreepsAttackEachUnit(params)
	local absTarget = params.absTarget
	local unit = params.unit
	local target = params.target
	local absUnit = unit:GetAbsOrigin()
	--
	if not unit.CanTFindPath then
		unit.CanTFindPath = false
	end
	--
	--local length = GridNav:FindPathLength(absTarget,absUnit)
	--local length = MyFindPathLength({abs1 = absTarget, abs2 = absUnit})
	--local range = unit:GetAttackRange()
	-- if unit cant move then nothing do
	--if not GridNav:CanFindPath( absUnit,absTarget ) then
	--if not GridNav:IsTraversable(absTarget) then
	if IsBlockedF( {unit = unit, unitAbs = absUnit} ) then
	--if false == true then
		if unit.CanTFindPath == false then
			--print("IsBlockedF")
			unit.CanTFindPath = true
			--unit:SetRenderColor(0,0,0)
			--unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
			unit:Hold()
			--unit:Stop()
		end
		return
	else
		--print("NO!")
		--print("GetPaddedCollisionRadius = ", unit:GetPaddedCollisionRadius())
		--unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		if unit.CanTFindPath then
			unit.CanTFindPath = false
			--unit:SetRenderColor(255,255,255)
			--unit:MoveToPosition(absUnit)
			--unit:Stop()
			--unit:MoveToPosition(absUnit)
			
			
			--ResolveNPCPositions(absUnit,unit:GetPaddedCollisionRadius())
		end
		unit:Interrupt()
	end
	--if length < range+300 then
		--print("1")
	--	unit:MoveToTargetToAttack(target)
	--else--if length < range+600 then
			--print("2")
			--unit:MoveToNPC(target)
		--	  unit:MoveToPosition(absTarget)
		--else
			--print("3")
	local fv = target:GetForwardVector()
    local front_position = absTarget + fv * 100
			unit:MoveToPositionAggressive(front_position)
		--
		
	--end
end











--[[	OLD MARKS, but mb need

function AICreepsAttackAllUnit(params)
	local tick = 0.01 --0.002
	--local tCreepsLoc = params.tCreepsLoc
	local index = params.index
	local target = params.target
	local absTarget = params.absTarget
	if index == 1 then
		for i=1, #tCreeps1 do
			Timers:CreateTimer(tick*i,
				function()
					AICreepsAttackEachUnit( {absTarget = absTarget,unit = tCreeps1[i],target = target} )
					return nil
				end)
		end
	else
		for i=1, #tCreeps2 do
			Timers:CreateTimer(tick*i,
				function()
					AICreepsAttackEachUnit( {absTarget = absTarget,unit = tCreeps2[i],target = target} )
					return nil
				end)
		end
	end
end


function AICreepsAttackComand(params)
	local tTargetBuf = params.tTargetBuf
	local tTargetBufAbs = params.tTargetBufAbs
	AICreepsAttack( {tCreeps = tCreeps1, index = 1, tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
	-- mini delay for
	Timers:CreateTimer(0.05,
	function()
		AICreepsAttack( {tCreeps = tCreeps2, index = 2, tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
	end)
end


function AICreepsAttack(params)
	local tTargetBuf = params.tTargetBuf
	local tTargetBufAbs = params.tTargetBufAbs
	--
	local index = params.index
	local tCreeps = params.tCreeps
	--
	if #tTargetBuf > 0 then
		local randomUnit = tCreeps[RandomInt(1,#tCreeps)]
		local absTarget = AICreepsAttackUpdateTarget( {index = index, targetCreep = randomUnit, tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
		AICreepsAttackAllUnit( {tCreepsLoc = tCreeps, target = tHeroTarget[index], absTarget = absTarget} )
	else
		for i=1, #tCreeps do
			tCreeps[i]:Hold()
		end
	end
	
end


function LiA:onThinkAIspellcast()
	--IsWave = false
	if IsWave then
		--if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not GameRules:IsGamePaused() then
			--AICreepsAttackSpellCast({ tBosses = {tBoss1,tBoss2} })
		end
	end
	--
	return 3.0
end


function AICreepsAttackComandForAfterCreateInit(params)
	tTargetParams = AICreepsAttackFindHeroes()
	local index = params.index
	--local tCreepsLoc = params.tCreepsLoc
	local targetCreep = params.targetCreep
	local tTargetBuf = tTargetParams.tTargetBuf
	local tTargetBufAbs = tTargetParams.tTargetBufAbs
	--local randomUnit = tCreepsLoc[RandomInt(1,#tCreepsLoc)]
	local absTarget = AICreepsAttackUpdateTarget( {index = index, targetCreep = targetCreep, tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
	return absTarget
	
end

function AICreepsAttackComandForAfterCreate(params)
	--tTargetParams = AICreepsAttackFindHeroes()
	--local tTargetBuf = tTargetParams.tTargetBuf
	--local tTargetBufAbs = tTargetParams.tTargetBufAbs
	local index = params.index
	local unit = params.unit
	local absTarget = params.absTarget
	--local tCreepsLoc = params.tCreepsLoc
	--if index == 1 then
	--	tCreepsLoc = tCreeps1
	--else
	--	tCreepsLoc = tCreeps2
	--end
	--local absTarget = AICreepsAttackUpdateTarget( {index = index, tCreepsLoc = tCreepsLoc, tTargetBuf = tTargetBuf, tTargetBufAbs = tTargetBufAbs} )
	--print("absTarget = ",absTarget)
	--print("unit = ",unit)
	--print("tHeroTarget[index]} = ",tHeroTarget[index])
	--AICreepsAttackEachUnit( {absTarget = absTarget,unit = unit,target = tHeroTarget[index]} )
	AICreepsAttackAllUnit( {tCreepsLoc = {unit}, target = tHeroTarget[index], absTarget = absTarget} )
end











function AICreepsAttackSpellCast(params)
	local tBosses = params.tBosses
	local table_near_enemy
	local radius
	local ability
	if WAVE_NUM == 1 then
		-- spell stomp: radius, enemy
		-- 1_wave_stomp
		radius = 250
		for i=1, #tBosses do
			if tBosses[i] ~= nil and tBosses[i]:IsAlive() then
				ability = tBosses[i]:FindAbilityByName("1_wave_stomp")
				if ability:IsCooldownReady() then
					table_near_enemy = FindUnitsInRadius(tBosses[i]:GetTeam(),
												 tBosses[i]:GetAbsOrigin(),
												 nil,
												 radius,
												 DOTA_UNIT_TARGET_TEAM_ENEMY,
												 DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
												 DOTA_UNIT_TARGET_FLAG_NONE,
												 FIND_ANY_ORDER,
												 false)
					if #table_near_enemy>0 then
						tBosses[i]:CastAbilityNoTarget(ability, tBosses[i]:GetPlayerOwnerID())
					end
				end
			end
		end
	elseif WAVE_NUM == 3 then
	
	end
end

]]