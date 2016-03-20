function CDOTA_PlayerResource:ModifyLumber(playerID, lumber)
	if not PlayerResource:IsValidPlayerID(playerID) then 
		error("[PlayerResource:ModifyLumber] Invalid playerID")
		return
	end
	
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)

	if not CustomPlayerResource.lumber[playerID] then
		CustomPlayerResource.lumber[playerID] = 0
	end


	CustomPlayerResource.lumber[playerID] = CustomPlayerResource.lumber[playerID] + lumber

	if CustomPlayerResource.lumber[playerID] < 0 then
		CustomPlayerResource.lumber[playerID] = 0
	end

	CustomNetTables:SetTableValue("lia_player_table", tostring(playerID), {lumber = CustomPlayerResource.lumber[playerID]})
end

function CDOTA_PlayerResource:GetLumber(playerID)
	if not PlayerResource:IsValidPlayerID(playerID) then 
		error("[PlayerResource:GetLumber] Invalid playerID")
		return
	end

	if not CustomPlayerResource.lumber[playerID] then
		CustomPlayerResource.lumber[playerID] = 0
	end

	return CustomPlayerResource.lumber[playerID]
end

function CDOTA_PlayerResource:SetReadyToRound(playerID,ready)
	if not PlayerResource:IsValidPlayerID(playerID) then 
		error("[PlayerResource:SetReadyToRound] Invalid playerID")
		return
	end

	CustomPlayerResource.readyToRound[playerID] = ready

	CustomNetTables:SetTableValue("lia_player_table", tostring(playerID), {readyToRound = ready})
end

function CDOTA_PlayerResource:IsReadyToRound(playerID)
	if not PlayerResource:IsValidPlayerID(playerID) then 
		error("[PlayerResource:IsReadyToRound] Invalid playerID")
		return
	end

	if not CustomPlayerResource.readyToRound[playerID] then
		CustomPlayerResource.readyToRound[playerID] = false
	end

	return CustomPlayerResource.readyToRound[playerID]
end

function CDOTA_PlayerResource:GetNumPlayersReadyToRound()
	local n = 0
	for _,v in pairs(CustomPlayerResource.readyToRound) do
		if v then
			n = n + 1
		end
	end
	return n
end

function CDOTA_PlayerResource:ClearReadyToRound()
	local table = CustomPlayerResource.readyToRound
	for playerID,ready in pairs(table) do
		table[playerID] = false
		CustomNetTables:SetTableValue("lia_player_table", tostring(playerID), {readyToRound = false})
	end
end

-------------------------------------------------------------------------------------------------

if not CustomPlayerResource then 
	CustomPlayerResource = {} 
	CustomPlayerResource.lumber = {}
	CustomPlayerResource.readyToRound = {}
end