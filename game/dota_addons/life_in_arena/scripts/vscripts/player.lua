CustomPlayerResource = CustomPlayerResource or {}
CustomPlayerResource.data = CustomPlayerResource.data or {}

function CDOTA_PlayerResource:ModifyLumber(playerID, lumber)
	CustomPlayerResource.data[playerID].lumber = CustomPlayerResource.data[playerID].lumber + lumber

	--CustomNetTables:SetTableValue("lia_player_table", "Player"..playerID, CustomPlayerResource[player])
	--DeepPrintTable(CustomNetTables:GetTableValue("lia_player_table", "PlayersLumber"))
end

function CDOTA_PlayerResource:GetLumber(playerID)
	return CustomPlayerResource.data[playerID].lumber 
end

function CDOTA_PlayerResource:SetReadyToRound(playerID,ready)
	CustomPlayerResource.data[playerID].readyToRound = ready

	--CustomNetTables:SetTableValue("lia_player_table", "Player"..playerID, CustomPlayerResource[playerID])
	--DeepPrintTable(CustomNetTables:GetTableValue("lia_player_table", tostring(playerID)))
end

function CDOTA_PlayerResource:IsReadyToRound(playerID)
	return CustomPlayerResource.data[playerID].readyToRound
end

function CDOTA_PlayerResource:GetNumPlayersReadyToRound()
	local n = 0
	for _,v in pairs(CustomPlayerResource.data) do
		if type(v) == "table" then
			if v.readyToRound then
				n = n + 1
			end
		end
	end
	return n
end

function CDOTA_PlayerResource:ClearReadyToRound()
	for playerID,playerTable in pairs(CustomPlayerResource.data) do
		playerTable.readyToRound = false
		--CustomNetTables:SetTableValue("lia_player_table", "Player"..playerID, playerTable)
	end
end

function CDOTA_PlayerResource:GetPlayerRating(playerID)
	return CustomPlayerResource.data[playerID].rating
end

function CDOTA_PlayerResource:IncremetCreepKills(playerID)
	CustomPlayerResource.data[playerID].killedCreeps = CustomPlayerResource.data[playerID].killedCreeps + 1
end

function CDOTA_PlayerResource:IncremetBossKills(playerID)
	CustomPlayerResource.data[playerID].killedBosses = CustomPlayerResource.data[playerID].killedBosses + 1
end

function CDOTA_PlayerResource:IncremetDeaths(playerID)
	CustomPlayerResource.data[playerID].heroDeaths = CustomPlayerResource.data[playerID].heroDeaths + 1
end

function CDOTA_PlayerResource:IncremetUpgrades(playerID)
	CustomPlayerResource.data[playerID].upgrades = CustomPlayerResource.data[playerID].upgrades + 1
end

function CDOTA_PlayerResource:GetPlayerIdAtPlace(nPlace)
	for playerID,playerData in pairs(CustomPlayerResource.data) do
		if nPlace == playerData.place then
			return playerID
		end
	end
	return -1
end

function StableSort(A)
  local itemCount=#A-1
  --print(itemCount)

 for i = 1, itemCount do
    	for i = 1, itemCount do
      		if A[i].rating < A[i + 1].rating then
        		A[i], A[i + 1] = A[i + 1], A[i]
      		elseif  A[i].rating == A[i + 1].rating and A[i].previousPlace > A[i + 1].previousPlace then
        		A[i], A[i + 1] = A[i + 1], A[i]
      		end
    	end
  	end
end

function CustomPlayerResource:UpdatePlayersData()
	local playerPlaceTable = {}
	for playerID,playerData in pairs(CustomPlayerResource.data) do
		
		playerData.rating = math.floor( playerData.lumberSpent/333*100 *7 +.5 ) 
			+ playerData.killedCreeps * 2 
			+ playerData.killedBosses * 20 
			+ playerData.heroDeaths * -15 

		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		if hero then 
			playerData.rating = playerData.rating + hero:GetLevel() * 30 - 30
		end	

		playerPlaceTable[playerData.place] = { playerID = playerID, rating = playerData.rating, previousPlace = playerData.place } 

	end
	--DeepPrintTable(playerPlaceTable)
	--print("111")
	StableSort(playerPlaceTable)

	--DeepPrintTable(playerPlaceTable)
	for i = 1 , #playerPlaceTable do
		CustomPlayerResource.data[playerPlaceTable[i].playerID].place = i
	end
	

	for playerID,playerData in pairs(CustomPlayerResource.data) do
		--print(playerID, playerData.place, playerData.rating)
		CustomNetTables:SetTableValue("lia_player_table", "Player"..playerID, playerData)
	end

	return 1
end


function CustomPlayerResource:InitPlayer(playerID)

	if not self.data[playerID] then
	 	CustomPlayerResource.counter = (CustomPlayerResource.counter or 0) + 1
		self.data[playerID] = {}
		self.data[playerID].lumber = 0
		self.data[playerID].lumberSpent = 0
		self.data[playerID].readyToRound = false
		self.data[playerID].heroDeaths = 0
		self.data[playerID].killedCreeps = 0
		self.data[playerID].killedBosses = 0
		self.data[playerID].upgrades = 0
		self.data[playerID].rating = 0
		self.data[playerID].place = CustomPlayerResource.counter
	end

	GameRules:GetGameModeEntity():SetContextThink("playerStatsUpdater",Dynamic_Wrap(CustomPlayerResource,"UpdatePlayersData"),0.1)

end

