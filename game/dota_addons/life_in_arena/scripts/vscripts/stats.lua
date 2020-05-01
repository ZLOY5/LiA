Stats = Stats or {}

Stats.host = IsInToolsMode() and "http://127.0.0.1:3000" or ""
Stats.version = "v1"


if IsInToolsMode() then
    local oldGetter = CDOTA_PlayerResource.GetSteamID

    CDOTA_PlayerResource.GetSteamID = function(self, playerId)
        local steamId = oldGetter(self, playerId)

        if tostring(steamId) == "0" then
            return playerId
        end

        return steamId
    end
end

function GetPlayerIDBySteamID(steamID)
	for i = 0, 63 do
		if tostring(PlayerResource:GetSteamID(i)) == steamID then
			return i
		end
	end
end

function Stats.MatchStart()
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end

	local url = "/api/matches/init"
	local data = {}
	data.version = Stats.version
	data.matchid = tostring(GameRules:GetMatchID())
	data.cheats = GameRules:IsCheatMode()
	data.mode = Survival.IsExtreme and "extreme" or (Survival.IsLight and "light" or "none")

	data.players = {}

	for i = 0, 63 do
		if PlayerResource:IsValidTeamPlayerID(i) then
			table.insert(data.players, tostring(PlayerResource:GetSteamID(i)))
		end
	end

	Stats.SendData(url, data, Stats.MatchStartResponse, 5)
end

function Stats.MatchStartResponse(data) 
	print(data)
end

function Stats.MatchResult(win)
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	
	local url = "/api/matches/end"
	local data = {}
	data.version = Stats.version
	data.matchid = tostring(GameRules:GetMatchID())
	data.win = win
	data.wave = Survival.nRoundNum
	data.mode = Survival.IsExtreme and "extreme" or (Survival.IsLight and "light"  or "none")

	data.players = {}
	CustomPlayerResource:UpdatePlayersData()

	for pID = 0, 63 do
		if PlayerResource:IsValidTeamPlayerID(pID) then
			local pData = {}
			pData.steamid64 = tostring(PlayerResource:GetSteamID(pID))
			
			pData.creeps = PlayerResource:GetCreepKills(pID)
			pData.bosses = PlayerResource:GetBossKills(pID)
			pData.deaths = PlayerResource:GetDeaths(pID)
			pData.upgrades = PlayerResource:GetUpgradesPercent(pID)
			pData.rating = PlayerResource:GetPlayerRating(pID)

			local hero = PlayerResource:GetSelectedHeroEntity(pID)
			if hero then 
				for i=0,5 do
					local item = hero:GetItemInSlot(i)
					if item then
						pData["item"..i] = item:GetAbilityKeyValues().ID
					end
				end
			end

			--pData.team = PlayerResource:GetTeam(pID)

			table.insert(data.players, pData)
		end
	end

	Stats.SendData(url, data, Stats.MatchEndResponse, 5)
end

function Stats.MatchEndResponse(data) 
	print(data)
end

function Stats.SendData(url, data, callback, rep)
    local req = CreateHTTPRequestScriptVM("POST", Stats.host..url)
    local encoded = json.encode(data)
    print("[Stats] URL", url, "payload:", encoded)
    req:SetHTTPRequestHeaderValue("X-GAME-SERVER-KEY", GetDedicatedServerKeyV2(Stats.version))
    req:SetHTTPRequestRawPostBody("application/json", encoded)
    req:Send(function(res)
        if res.StatusCode ~= 200 then
            print("[Stats] Server connection failure, code", res.StatusCode)

            if rep ~= nil and rep > 0 then
                print("[Stats] Repeating in 3 seconds")

                Timers:CreateTimer(3, function() Stats.SendData(url, data, callback, rep - 1) end)
            end

            return
        end

        if callback then
            print("[Stats] Received", res.Body)
            local obj, pos, err = json.decode(res.Body)
            callback(obj, pos, err)
        end
    end)
end

--Stats.MatchResult(true)