function ShowCenterMessage(msg, dur, wave)
	FireGameEvent("show_center_message",{message = msg,duration = dur}) 
	if wave then
		Timers:CreateTimer(0.01, function() FireGameEvent("show_center_message_fix",{wave = wave}) return nil end)
	end
end

function ResetAllAbilitiesCooldown(unit)
	local abilities = unit:GetAbilityCount()
	for i = 1, abilities-1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and not ability:IsCooldownReady() then
			ability:EndCooldown()
		end
	end
end

function GetItemInInventory(unit,itemName)
	for i = 0, 5 do
		local item = unit:GetItemInSlot(i) 
		if item then
			if item:GetName() == itemName then
				return item 
			end
		end
	end
	return nil
end

POPUP_SYMBOL_PRE_PLUS = 0
POPUP_SYMBOL_PRE_MINUS = 1
POPUP_SYMBOL_PRE_SADFACE = 2
POPUP_SYMBOL_PRE_BROKENARROW = 3
POPUP_SYMBOL_PRE_SHADES = 4
POPUP_SYMBOL_PRE_MISS = 5
POPUP_SYMBOL_PRE_EVADE = 6
POPUP_SYMBOL_PRE_DENY = 7
POPUP_SYMBOL_PRE_ARROW = 8

POPUP_SYMBOL_POST_EXCLAMATION = 0
POPUP_SYMBOL_POST_POINTZERO = 1
POPUP_SYMBOL_POST_MEDAL = 2
POPUP_SYMBOL_POST_DROP = 3
POPUP_SYMBOL_POST_LIGHTNING = 4
POPUP_SYMBOL_POST_SKULL = 5
POPUP_SYMBOL_POST_EYE = 6
POPUP_SYMBOL_POST_SHIELD = 7
POPUP_SYMBOL_POST_POINTFIVE = 8

function PopupNumbers(player,target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx
    if player then
    	pidx = ParticleManager:CreateParticleForPlayer(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target, player)
    else
    	pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()
    end
    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end


function SetCameraToPosForPlayer(playerID,vector)
	local camera_guy = CreateUnitByName("camera_guy", vector, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Timers:CreateTimer(1,function() camera_guy:RemoveSelf() end)
	if playerID == -1 then --для всех игроков
		DoWithAllHeroes(function(hero)
			PlayerResource:SetCameraTarget(hero:GetPlayerID(),camera_guy)
		end)
		Timers:CreateTimer(0.1,function()
			DoWithAllHeroes(function(hero)
				PlayerResource:SetCameraTarget(hero:GetPlayerID(),nil)
			end)
		end)
	else --для одного игрока
		PlayerResource:SetCameraTarget(playerID,camera_guy)
		Timers:CreateTimer(0.1,function()
			PlayerResource:SetCameraTarget(playerID,nil)
		end)
	end

	
end

function DistanceBetweenPoints(v1,v2)
	return math.sqrt(math.pow(v2.x - v1.x,2) + math.pow(v2.y - v1.y,2) + math.pow(v2.z - v1.z,2))
end

function CleanUnitsOnMap()
	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 9999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, true)
    for _,unit in pairs(units) do
        if not unit:IsRealHero() and not unit.destructable then
        	--print(unit:GetUnitName())
        	unit.cleanerKilled = 1
            unit:ForceKill(true)
        end
    end
end

function PrintTable(title,table)
	print(title)
	for k,v in pairs(table) do
		print(k,v)
	end
	print("--------------------End of table--------------------------")
end


function StartTimer(text, number, time)
	LiA.nCOUNTDOWNTIMER = time

	local minutes = math.floor(time / 60)
    local seconds = time - (minutes * 60)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)
    local broadcast_gametimer = 
        {
            timer_minute_10 = m10,
            timer_minute_01 = m01,
            timer_second_10 = s10,
            timer_second_01 = s01,
            text = text;
            number = number;
        }
    CustomGameEventManager:Send_ServerToAllClients( "set_timer", broadcast_gametimer )
    Timers:CreateTimer("lia_timer_countdown",
        {
            endTime = 1, 
            callback = CountdownTimer
        }
    )
end

function CountdownTimer()
	LiA.nCOUNTDOWNTIMER = LiA.nCOUNTDOWNTIMER - 1
	local t = LiA.nCOUNTDOWNTIMER
	if t > 0 then 
		local minutes = math.floor(t / 60)
	    local seconds = t - (minutes * 60)
	    local m10 = math.floor(minutes / 10)
	    local m01 = minutes - (m10 * 10)
	    local s10 = math.floor(seconds / 10)
	    local s01 = seconds - (s10 * 10)
	    local broadcast_gametimer = 
	        {
	            timer_minute_10 = m10,
	            timer_minute_01 = m01,
	            timer_second_10 = s10,
	            timer_second_01 = s01,
	        }
	    CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
	else 
		CustomGameEventManager:Send_ServerToAllClients( "hide_timer", nil )
		return 0
	end 
	return 1
end

function IsValidAlive( unit )
	return (IsValidEntity(unit) and unit:IsAlive())
end

function TableFindKey( table, val )
    if table == nil then
        print( "nil" )
        return nil
    end

    for k, v in pairs( table ) do
        if v == val then
            return k
        end
    end
    return nil
end

function TableCount( t )
    local n = 0
    for _ in pairs( t ) do
        n = n + 1
    end
    return n
end

function getIndex(list, element)
    if list == nil then return false end
    for i=1,#list do
        if list[i] == element then
            return i
        end
    end
    return -1
end

function IsFlagSet(number,flag)
	return (number % (2*flag) >= flag)
end