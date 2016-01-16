runeTypes = {
	item_lia_rune_of_healing = 1,
	item_lia_rune_of_mana = 1,
	item_lia_rune_of_restoration = 1, 
	item_lia_rune_of_speed = 1,
	item_lia_rune_of_strength = 1,
	item_lia_rune_of_agility = 1,
	item_lia_rune_of_intellect = 1,
	item_lia_rune_of_lifesteal = 1,
	item_lia_rune_of_luck = 1,
	item_lia_rune_of_protection = 1,
	item_lia_rune_gold = 0.5,
	item_lia_rune_lumber = 0.5, --эта руна будет появляться в два раза реже руны с значением 1
}

runeSpawnTime = 60 --период появления рун
Q = 1

runesSpawnChanceSumm = 0
for k,v in pairs(runeTypes) do
	runesSpawnChanceSumm = runesSpawnChanceSumm + v
	runeTypes[k] = runesSpawnChanceSumm
end


function GetRandomRuneType()
	local f = RandomFloat(0,runesSpawnChanceSumm)
	for k,v in pairs(runeTypes) do
		if v>=f then
			return k
		end
	end
end

function GetRuneSpawnPos()
	if runeSpawnRegionType == "rectangle" then
		return Vector(RandomFloat(vRuneSpawnMin.x,vRuneSpawnMax.x), RandomFloat(vRuneSpawnMin.y,vRuneSpawnMax.y), 0)
	elseif runeSpawnRegionType == "circle" then
		return vRuneSpawnMin+RandomVector(RandomInt(0,700))
	end
end

function SpawnRune()
	local rune = CreateItem(GetRandomRuneType(), nil, nil)
	CreateItemOnPositionSync(GetRuneSpawnPos(), rune)
end

function StartRunesSpawn()
	Timers:CreateTimer("LiAruneSpawner",
		{
            endTime = runeSpawnTime, 
            callback = function() 
            	SpawnRune() 
            	Q = Q + 1
            	if Q == 100 then 
            		return nil 
            	end
            	return runeSpawnTime 
            end
        }
    )
end

function StopRunesSpawn()
	Timers:RemoveTimer("LiAruneSpawner")
end

function SetRuneSpawnRegion(regionType,vMin,vMax)
	if regionType == "circle" then
		runeSpawnRegionType = regionType
		vRuneSpawnMin = vMin
	elseif regionType == "rectangle" then
		runeSpawnRegionType = regionType
		vRuneSpawnMin = vMin
		vRuneSpawnMax = vMax
	end
end

--[[
test = {}
for i=1,10000 do
	q = GetRandomRuneType()
	if test[q] then 
		test[q] = test[q] + 1
	else
		test[q] = 1
	end
	--print(q)
	
end
DeepPrintTable(test)
]]